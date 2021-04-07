module JsonApiFilter
  module FieldFilters
    class Searcher < Base
  
      # @return [ActiveRecord_Relation]
      def predicate
        scope.send(values.keys.first, values.values.first)
      end

    end
  end
end
