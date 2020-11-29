# Define: pf::table
#
# @param class_list A list of class names for which to lookup hosts and return
# the fact_list for addresses.
#
# @param ip_list A list of IP addresses to include in the table.  These values
# are always added to the table.
#
# @param fact_list Alter the data returned during a class lookup as in the case
# when using the class_list param.  This is only used if common_class and
# common_class_param are not used.
#
# @param common_class @param common_class_param
#

define pf::table (
  Array[String] $class_list            = [],
  Array[String] $ip_list               = [],
  Array[String] $fact_list             = [],
  Optional[String] $common_class       = undef,
  Optional[String] $common_class_param = undef,
) {

  # TODO should class_list be called node_filter?  This might make it easier to
  # filter the nodes that we want, and it looks like a list of classes is still
  # an appropriate use.  Perhaps a rename here would simply make query results
  # more powerful, and perhaps more understandable.

  include pf

  if $class_list.size > 0 {
    if $common_class and $common_class_param {
      $class_ip_list = pf::common_class_param_value_list(
        $class_list,
        $common_class,
        $common_class_param
      )
    } else {
      if $fact_list {
        $class_ip_list = pf::class_ip_list($class_list, $fact_list)
      } else {
        $class_ip_list = pf::class_ip_list($class_list)
      }
    }
    $final_ip_list = concat($class_ip_list, $ip_list)
  } else {
    $final_ip_list = $ip_list
  }

  concat::fragment { "/etc/pf.d/tables/${name}.pf":
    target  => "${pf::pf_d}/tables.pf",
    content => epp('pf/table.epp',{
      'table_name'    => $name,
      'ip_list' => $final_ip_list,
      }),
  }
}
