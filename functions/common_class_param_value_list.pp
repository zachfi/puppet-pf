function pf::common_class_param_value_list(
  Array[String] $class_list  = [],
  String $common_class       = '',
  String $common_class_param = '',
) {

  pf::normalize_class_names($class_list).map |$c| {
    $nodes_query = "nodes {
      resources {
        type = 'Class' and title = '${c}'
      }
    }"

    $resources_query = "resources {
      type = 'Class'
      and title = '${common_class}'
      and ${nodes_query}
    }"

    puppetdb_query($resources_query).map |$x| {
      $x['parameters'][$common_class_param]
    }
  }.flatten.delete_undef_values.unique.sort
}
