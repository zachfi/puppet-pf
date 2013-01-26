define pf::table (
  $pfconf = '/etc/pf.conf',
  $order  = '45',
  $list
){

  $table_line = inline_template("table <<%=name%>> { <%= list.to_a.join(' ') %> }")

  concat::fragment { "PF Table: ${name}":
    order   => $order,
    target  => $pfconf,
    content => "${table_line}\n",
  }

}
