function pf::class_ip_list (
  Array[String] $class_list = [],
  Array[String] $facts_list = ['ipaddress', 'ipaddress6'],
) {

  $r = pf::normalize_class_names($class_list).map
  notify { 'debug: ':
    message => $r,
  }

  pf::normalize_class_names($class_list).map |$x| {
    notify { "debug: ${x}": }

    $query = 'Class["' + $c + '"]'
    $results = query_facts($query, facts_list)
  }

  $a = []
}
