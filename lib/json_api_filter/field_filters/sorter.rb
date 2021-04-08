module JsonApiFilter
  module FieldFilters
    class Sorter < Base
  
      # @return [ActiveRecord_Relation]
      def predicate
        return nil if values["by"].nil?
        scope.order(values["by"] => order)
      end

      private

      def order
        ActiveModel::Type::Boolean.new.cast(values["desc"]) ? :desc : :asc
      end
    
    end
  end
end
