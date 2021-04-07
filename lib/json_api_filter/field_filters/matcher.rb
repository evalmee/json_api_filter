module JsonApiFilter
  module FieldFilters
    class Matcher < Base
  
      # @return [ActiveRecord_Relation]
      def predicate
        values.map do |key, value|
          ::JsonApiFilter::FieldFilters::Compare.compare(scope, key, :eq, ::JsonApiFilter::ValueParser.parse(value))
        end.reduce(&:merge)
      end
    
    end
  end
end
