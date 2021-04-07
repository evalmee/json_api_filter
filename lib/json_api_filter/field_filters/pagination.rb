module JsonApiFilter
  module FieldFilters
    class Pagination < Base
  
      # @return [ActiveRecord_Relation]
      def predicate
        page = values["page"]
        per_page = values["perPage"]
        result = scope
        unless page.nil? || per_page.nil? || per_page == "-1"
          result = result.limit(per_page.to_i)
          result = result.offset((page.to_i - 1) * per_page.to_i)
        end
        result
      end

    end
  end
end
