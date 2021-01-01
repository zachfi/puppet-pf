function pf::normalize_class_names(
  Array[String] $class_list = [],
) {
  $class_list.map |$x| {
    $x.split('::').map|$p| {
      $p.capitalize
    }.join('::')
  }
}
