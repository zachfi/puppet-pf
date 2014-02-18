# Puppet-pf

A Puppet module for managing PF rules on BSD.  This module is pretty basic.
It only wraps the logic necessary to deploy a `pf.conf` file and the necessary
parsing and loading of the rules deployed.

## Usage

To use the PF module, you only need pass in a template.

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

Now this allows you to put the bulk of the code in common templates that can be
distributed to multiple systems.  This means that in order to make changes to
the majority of your firewalls, you can do so with just a change to a single
firewall.  Obviously, how this structure is laid out and the usefulness of
doing so will be dependent on the environment within which PF is deploy.

### Dynamic rules with PuppetDB

Coming soon.
