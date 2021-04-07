
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
            compare(column, key, value)
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
      
      def compare(column, method, value)
        if WHERE_METHODS[method.to_sym] == "="
          # prefer this method for eq as it implicitely transforms enum into their integer representation
          scope.where(column => value)
        else
          scope.where("#{column} #{WHERE_METHODS[method.to_sym]} ?", value)
        end
      end
    
    end
  end
end
