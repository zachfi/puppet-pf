# Puppet-pf

[![Puppet Forge](https://img.shields.io/puppetforge/v/zleslie/pf.svg)]() [![Build Status](https://travis-ci.org/xaque208/puppet-pf.svg?branch=master)](https://travis-ci.org/xaque208/puppet-pf)

A Puppet module for managing PF rules on BSD.  This module is pretty basic.
It only wraps the logic necessary to deploy a `pf.conf` file and the necessary
parsing and loading of the rules deployed.

## Usage

To use the PF module, you only need pass in a template.

For Puppet 3.x support, use the module version 0.1.x.

### With Hiera

If you are using Hiera, the following items will take care of you.

``` Puppet
include pf
```

Then set `pf::template` to a value that you would pass to the `template()`
function, as you would on a `file` resource.  For example:

``` Yaml
pf::template: 'site/mynodepf.conf.erb'
```

Then for each node that uses PF, simply build a template for each node where
necessary.

### Fun with templates

Templates are cool for many reasons.  One of them is the fact that you can
include templates from inside templates.  As an example, you might keep pf
*options, macros, and tables* each in a file that is common to all your hosts.
Then only use differences where needed.  For example, a firewall node template
might look like the following.

``` ERB
<%= scope.function_template(['profile/network/firewall/pf/_options.erb']) %>
<%= scope.function_template(['profile/network/firewall/pf/_macros.erb']) %>
<%= scope.function_template(['profile/network/firewall/pf/_tables.erb']) %>
<%= scope.function_template(['profile/network/firewall/pf/_nat.erb']) %>
<%= scope.function_template(['profile/network/firewall/pf/_filter.erb']) %>
<%= scope.function_template(['profile/network/firewall/pf/_filter/_siteA_ipsec.erb']) %>

# Allow sasyncd in from peer
pass in on $ext_if proto tcp from $siteA_secondary_ext to $siteA_primary_ext port {isakmp}
```

This allows you to put the bulk of the code in common templates that can be
distributed to multiple systems, which helps reduce the number of files that
need modifying to make change to a potential large number of systems.  This is
environment *dependent*.

### Dynamic tables with PuppetDB

Tables in PF hold groups of addresses for speedy lookup and simplified rule
sets.  This combined with PuppetDB queries makes for some interesting code.
You can use the `pf::table` defined type to specify a list of classes, who's IP
addresses should be in a table.

```Puppet
pf::table {'ldap_servers':
    class_list => ['profile::ldap::servers'],
}
```

The above code will all a PF table entry to `/etc/pf.d/tables.pf` that you can
simply include in your main template with a simple `include
"/etc/pf.d/tables.pf`.  Now you can use the `<ldap_servers>` table in your rule
set like you would with any other PF table.

```pf
pass in proto { tcp udp } from <local_nets> to <auth_servers> port 88
pass in proto tcp from <local_nets> to <auth_servers> port { 636 749 }
```

This table is populated by querying PuppetDB for all nodes who have the class
`profile::ldap::servers` in their catalog, and returning returning the values
for `ipaddress` and `ipaddress6` from those nodes, and adding them to the
  table.  This doesn't work for all scenarios, for example, if the IP you want
  to add to a table is not in either of those facts.

#### More flexible table data using a common class

In the case where a node's `ipaddress` or `ipaddress6` is not the desired value
to enter a table, this data can be referenced from another class.  Consider the following resources

``` Puppet
class profile::network::host ($default_address) {}

pf::table {'ldap_servers':
    class_list         => ['profile::ldap::servers'],
    common_class       => 'profile::network::host',
    common_class_param => 'default_address'
}
```

In this case, the `profile::network::host::default_address` can be set in
hiera, on a specific node.  This will cause the `pf::table` resource to first
look for nodes that have included the `profile::ldap::servers` class, then from
each of those nodes, look up the value of `default_address` on the
`profile::network::host` class.  This allows the `default_address` to be
overridden with something more creative, like an array of facts like
`[networking.lo1.ip6, networking.lo1.ip4]` or some such.  This comes in quite
handy when nodes in the environment wish to be referenced by a fact that is not
the `ipaddress` or `ipaddress6` fact.


