module Puppet::Parser::Functions
  newfunction(:get_common_class_param_value_list,
              arity: 3,
              type: :rvalue) do |args|

    node_class_list    = args.shift
    common_class       = args.shift
    common_class_param = args.shift

    def normalize_class_names(names)
      Array(names).map do |c|
        # We need to get the class names in the correct capitalization
        c.split('::').map(&:capitalize).join('::')
      end
    end

    def get_class_values(query, node_filter)
      Puppet.debug("retrieving class values for #{query} filter #{node_filter}")
      results = function_query_resources([
        node_filter,
        query,
        false
      ])
      # The results come back as a single item array, so it looks
      results.each{|i|
        yield i['parameters']
      }
    end

    ip_list = []
    # normal_common_class = normalize_class_names(common_class).map.first
    query = "Class[\"#{common_class}\"]"

    normalize_class_names(node_class_list).each do |c|
      node_filter = "Class[#{c}]"

      get_class_values(query, node_filter) do |params|
        Puppet.debug("get_common_class_param_value_list(): #{params}")
        value = params[common_class_param]
        Array(value).each do |v|
          ip_list << v
        end
      end
    end

    ip_list.sort.reject { |i| i.nil? || i == '' }.uniq
  end
end
