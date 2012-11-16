class pf (
  $pfconf   = '/etc/pf.conf',
  $pfdir    = '/etc/pf',
  $sitename = hiera('sitename')
){

  concat { $pfconf:
    owner  => root,
    group  => 0,
    mode   => 640,
    notify => Exec["reload_pf"],
  }

  concat::fragment { "pf.conf_options":
    order   => '01',
    target  => $pfconf,
    source => [
      "puppet:///modules/${sitename}/etc/pf.conf.options.${fqdn}",
      "puppet:///modules/pf/pf.conf.options"
      ],
  }

  concat::fragment { "pf.conf_macros":
    order   => '03',
    target  => $pfconf,
    source => [
      "puppet:///modules/${sitename}/etc/pf.conf.macros.${fqdn}",
      "puppet:///modules/pf/pf.conf.macros"
      ],
  }

  concat::fragment { "pf.conf_translation":
    order   => '31',
    target  => $pfconf,
    source => [
      "puppet:///modules/${sitename}/etc/pf.conf.translation.${fqdn}",
      "puppet:///modules/pf/pf.conf.translation"
      ],
  }

  concat::fragment { "pf.conf_tables":
    order   => '41',
    target  => $pfconf,
    source => [
      "puppet:///modules/${sitename}/etc/pf.conf.tables.${fqdn}",
      "puppet:///modules/pf/pf.conf.tables"
      ],
  }

  concat::fragment { "pf.conf_filtering":
    order   => '51',
    target  => $pfconf,
    source => [
      "puppet:///modules/${sitename}/etc/pf.conf.filtering.${fqdn}",
      "puppet:///modules/pf/pf.conf.filtering"
      ],
  }

  service { "pf":
    enable  => true,
    ensure  => running,
    require => Concat[$pfconf],
  }

  service { "pflog":
    enable => true,
    ensure => running,
  }

  exec { "reload_pf":
    path        => '/sbin',
    command     => "pfctl -nf ${pfconf} && pfctl -f ${pfconf}",
    refreshonly => true,
  }

}
