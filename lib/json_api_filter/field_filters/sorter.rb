module JsonApiFilter
  module FieldFilters
    class Sorter < Base
  
      # @return [ActiveRecord_Relation]
      def predicate
        return nil if values["by"].nil?
        result = scope
        result = result.order(values["by"])
        result = result.reverse_order if values["desc"] == "true"
        result
      end
    
    end
  end
end
