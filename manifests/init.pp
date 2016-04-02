class pf (
  $template       = undef,
  String $pfctl          = '/sbin/pfctl',
  String $tmpfile        = '/tmp/pf.conf',
  String $conf           = '/etc/pf.conf',
  String $pf_d           = '/etc/pf.d',
  Boolean $manage_service = $pf::params::manage_service,
  Boolean $service_enable = $pf::params::service_enable
) inherits pf::params {

  file { $pf_d:
    ensure  => directory,
    owner   => 'root',
    group   => '0',
    recurse => true,
    purge   => true,
  }

  concat { "${pf_d}/tables.pf":
    owner  => 'root',
    group  => '0',
    mode   => '0600',
    notify => Exec['pfctl_update']
  }

  if $template {
    file { $tmpfile:
      owner   => '0',
      group   => '0',
      mode    => '0600',
      content => template($template),
      notify  => Exec['pfctl_update'],
    }

    file { $conf:
      ensure => 'file',
      owner  => '0',
      group  => '0',
      mode   => '0600',
    }

    if $manage_service {
      $service_ensure = $service_enable ? {
        true  => 'running',
        false => 'stopped',
      }

      service { 'pf':
        ensure  => $service_ensure,
        enable  => $service_enable,
        require => File[$conf],
        before  => Exec['pfctl_update'],
      }
    }

    exec { 'pfctl_update':
      command     => "${pfctl} -nf ${tmpfile} && cp ${tmpfile} ${conf} && ${pfctl} -f ${conf}",
      unless      => "/usr/bin/diff ${tmpfile} ${conf}",
      refreshonly => true,
    }
  } else {
    warning('in order to apply PF rules, you must specify a config template')
  }
}
