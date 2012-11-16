define pf::subconf (
  $pfconf = '/etc/pf.conf',
  $order  = '99',
  $rule
){

  concat::fragment { "PF RULE: ${confname}: ${rule}":
    order   => $order,
    target  => $pfconf,
    content => "# ${name}\n${rule}\n",
  }

}
