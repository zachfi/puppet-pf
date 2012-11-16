define pf::macro (
  $pfconf = '/etc/pf.conf',
  $order  = '04',
  $value
){

  $table_line = inline_template("<%=name%> = \"<%= value %>\"")

  concat::fragment { "PF Table: ${name}":
    order   => $order,
    target  => $pfconf,
    content => "${table_line}\n",
  }

}
