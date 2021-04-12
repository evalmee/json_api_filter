module JsonApiFilter
  module FieldFilters
    class Searcher < Base
  
      # @return [ActiveRecord_Relation]
      def predicate
        scope.where(id: scope.send(values.keys.first, values.values.first).select(:id))
      end

    end
  end
end
