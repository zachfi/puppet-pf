module Puppet::Parser::Functions
  newfunction(:get_class_ip_list,
              arity: 1,
              type: :rvalue) do |args|

    class_list = args.shift

    def self.normalize_class_names(names)
      Array(names).each do |c|
        # We need to get the class names in the correct capitalization
        yield c.split('::').map(&:capitalize).join('::')
      end
    end

    def self.get_fact_values(query, facts)
      results = function_query_facts([query, facts])
      facts.each do |f|
        results.each_key.map do |k|
          yield results[k][f].strip if results[k].keys.include? f
        end
      end
    end

    ip_list = []
    normalize_class_names(class_list) do |c|
      query = "Class[#{c}]"
      facts = %w(ipaddress ipaddress6)
      get_fact_values(query, facts) do |v|
        Puppet.debug("get_class_ip_list(): #{v}")
        ip_list << v
      end
    end

    ip_list.sort.reject { |i| i.nil? || i == '' }.uniq
  end
end
