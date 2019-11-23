function pf::common_class_param_value_list(
  Array[String] $class_list  = [],
  String $common_class       = '',
  String $common_class_param = '',
) {

  $common_class_query = "Class[\"${common_class}\"]"

  pf::normalize_class_names($class_list).map |$c| {
    $node_filter = "Class[\"${c}\"]"

    pf::class_values($node_filter, $common_class_query).map |$p| {
      $p[$common_class_param]
    }
  }.flatten.unique.sort

}
