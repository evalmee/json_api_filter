
module JsonApiFilter
  module FieldFilters
    class Compare < Base

      attr_reader :allowed_searches

      def initialize(scope, values, allowed_searches:)
        super(scope, values)
        @allowed_searches = allowed_searches
      end
  
      # @return [ActiveRecord_Relation]
      def predicate
        column = values.keys.first
        filter = values.first[1]
        filter.map do |key, value|
          if !WHERE_METHODS[key.to_sym].nil?
            self.class.compare(scope, column, key, value)
          elsif key == "search"
            next unless allowed_searches[:columns].keys.include?(column.to_sym)
            ::JsonApiFilter::FieldFilters::Searcher.new(
              scope,
              {allowed_searches[:columns][column.to_sym] => value}
            ).predicate
          else
            nil
          end
        end.compact.reduce(&:merge)
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
      
      def self.compare(scope, column, method, value)
        # convert enums to their integer representation
        unless scope.defined_enums[column].nil?
          value = scope.defined_enums[column][value]
        end
        if WHERE_METHODS[method.to_sym] == "=" && value.class == Array
          scope.where(column => value)
        else
          scope.where("#{column} #{WHERE_METHODS[method.to_sym]} ?", value)
        end
      end
    
    end
  end
end
