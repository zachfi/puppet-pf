# Define: pf::table
#
#
define pf::table (
  $class_list = undef,
  $ip_list    = undef,
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