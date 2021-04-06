
module JsonApiFilter
  module FieldFilters
    class Compare < Base
      
      def predicate
        column = values.keys.first
        filter = values.first[1]
        filter.map do |key, value|
          compare(column, key, value)
        end.reduce(&:merge)
      end
      
      private
      
      WHERE_METHODS = {
        eq: "=",
        ne: "!=",
        gt: ">",
        ge: ">=",
        lt: "<",
        le: "<=",
      }
      
      def compare(column, method, value)
        # convert enums to their integer representation
        unless scope.defined_enums[column].nil?
          value = scope.defined_enums[column][value]
        end
        scope.where("#{column} #{WHERE_METHODS[method.to_sym]} ?", value)
      end
    
    end
  end
end