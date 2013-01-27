define pf::filter (
  $pfconf = '/etc/pf.conf',
  $order  = '52',
  $rule   = [],
){

  concat::fragment { "PF RULE: ${confname}: ${rule}":
    order   => $order,
    target  => $pfconf,
    content => inline_template("# ${name}\n<%= rule.to_a.join('\n') %>\n"),
  }

}
