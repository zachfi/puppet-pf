# query for the paramaters of a given resource, using another resource as the
# filter.
function pf::class_values(
  String $node_filter,
  String $resource_query,
) {

  query_resources($node_filter, $resource_query, false).map |$x| {
    $x['parameters']
  }
}
