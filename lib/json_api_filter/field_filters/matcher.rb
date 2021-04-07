module JsonApiFilter
  module FieldFilters
    class Matcher < Base
  
      # @return [ActiveRecord_Relation]
      def predicate
        values.map do |key, value|
          scope.where(key => ::JsonApiFilter::ValueParser.parse(value))
        end.reduce(&:merge)
      end
    
    end
  end
end
