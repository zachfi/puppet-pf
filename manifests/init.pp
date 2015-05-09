class pf (
  $template       = undef,
  $pfctl          = '/sbin/pfctl',
  $tmpfile        = '/tmp/pf.conf',
  $conf           = '/etc/pf.conf',
  $manage_service = true,
  $service_ensure = true,
  $service_enable = true,
  $service_name   = 'pf',
){

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
      service { 'pf':
        ensure  => $service_ensure,
        enable  => $service_enable,
        name    => $service_name,
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
