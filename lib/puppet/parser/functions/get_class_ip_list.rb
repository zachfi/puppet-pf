module Puppet::Parser::Functions
  newfunction(:get_class_ip_list,
              :arity => 1,
              :type => :rvalue) do |args|

    class_list = args.shift

    def self.normalize_class_names(names)
      Array(names).each {|c|
        # We need to get the class names in the correct capitalization
        yield c.split('::').map {|i| i.capitalize }.join('::')
      }
    end

    def self.get_fact_values(query, facts)
      results = function_query_facts([query,facts])
      facts.each {|f|
        results.each_key.collect{|k,v|
          if results[k].keys.include? f
            yield results[k][f].strip
          end
        }
      }
    end

    ip_list = []
    self.normalize_class_names(class_list) {|c|
      query = "Class[#{c}]"
      facts = ['ipaddress', 'ipaddress6']
      self.get_fact_values(query, facts) {|v|
        Puppet.debug("get_class_ip_list(): #{v}")
        ip_list << v
      }
    }

    ip_list.sort.reject {|i| i.nil? or i == ''}.uniq
  end
end
