module JsonApiFilter
  module FieldFilters
    class Pagination < Base
  
      # @return [ActiveRecord_Relation]
      def predicate
        page = values["page"]
        per_page = values["perPage"]
        result = scope
        unless page.nil? || per_page.nil? || per_page == -1
          result = result.limit(per_page)
          result = result.offset((page - 1) * per_page)
        end
        result
      end

    end
  end
end
