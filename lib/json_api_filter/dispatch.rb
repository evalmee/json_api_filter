module JsonApiFilter
  class Dispatch
  
    attr_reader :params, :scope, :allowed_filters, :allowed_searches
    
    # @param [ActiveRecord::Base] scope
    # @param [Hash, ActionController::Parameters] params
    # @param [Array<Symbol>] allowed_filters
    def initialize(scope, params, allowed_filters:, allowed_searches:)
      @params = params
      @scope = scope
      @allowed_filters = allowed_filters
      @allowed_searches = allowed_searches
    end

    # @return [ActiveRecord_Relation]
    def process
      [
        scope.all,
        sort_predicate,
        filters_predicate,
        search_predicate,
        pagination_predicate
      ].compact.reduce(&:merge)
    end
    
    private
    
    # @return [ActiveRecord::Base, NilClass]
    def filters_predicate
      #todo : .with_indifferent_access add a dependency to ActiveSupport => to remove
      parser_params.fetch('filter', {}).map do |key, value|
        next unless filters.include?(key)
        next unless scope.column_names.include?(key)
        if value.class != ActiveSupport::HashWithIndifferentAccess
          next ::JsonApiFilter::FieldFilters::Matcher.new(scope, {key => value})
        end
        ::JsonApiFilter::FieldFilters::Compare.new(
          scope,
          {key => value},
          allowed_searches: allowed_searches
        )
      end.compact.map(&:predicate).reduce(&:merge)
    end

    # @return [ActiveRecord::Base, NilClass]
    def sort_predicate
      sort = parser_params[:sort]
      return nil if sort.blank?
      ::JsonApiFilter::FieldFilters::Sorter.new(scope, sort).predicate
    end

    # @return [ActiveRecord::Base, NilClass]
    def search_predicate
      return nil if parser_params[:search].blank?
      return nil if allowed_searches[:global].nil?
      ::JsonApiFilter::FieldFilters::Searcher.new(
        scope,
        {allowed_searches[:global] => parser_params[:search]}
      ).predicate
    end

    # @return [ActiveRecord::Base, NilClass]
    def pagination_predicate
      return nil if parser_params[:pagination].nil?
      ::JsonApiFilter::FieldFilters::Pagination.new(
        scope,
        parser_params[:pagination]
      ).predicate
    end
    
    # @return [Hash]
    def parser_params
      return params.to_unsafe_h if params.class == ActionController::Parameters
      
      params
    end
    
    # @return [Hash]
    def filters
      FilterAttributes.new(allowed_filters, parser_params[:filter]).process
    end
    
  end
end
