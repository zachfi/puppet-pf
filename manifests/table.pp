# Define: pf::table
#
#
define pf::table (
  Array $class_list = [],
  Array $ip_list    = [],
) {

  include pf

  if $class_list {
    $class_ip_list = get_class_ip_list($class_list)
  }

  $final_ip_list = concat($class_ip_list, $ip_list)

  concat::fragment { "/etc/pf.d/tables/${name}.pf":
    target  => "${pf::pf_d}/tables.pf",
    content => template('pf/table.erb'),
  }
}
