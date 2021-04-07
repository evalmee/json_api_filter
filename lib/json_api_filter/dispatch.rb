module JsonApiFilter
  class Dispatch
  
    attr_reader :params, :scope, :allowed_filters
    
    # @param [Object] params
    def initialize(scope, params, allowed_filters:)
      @params = params
      @scope = scope
      @allowed_filters = allowed_filters
    end
    
    def process
      [
        scope,
        filters_predicate,
        sort_predicate,
        search_predicate,
      ].compact.reduce(&:merge)
    end
    
    private
    
    def filters_predicate
      #todo : .with_indifferent_access add a dependency to ActiveSupport => to remove
      parser_params.fetch('filter',[]).map do |key, value|
        if value.class != ActiveSupport::HashWithIndifferentAccess
          next ::JsonApiFilter::FieldFilters::Matcher.new(scope, {key => value})
        end
        ::JsonApiFilter::FieldFilters::Compare.new(scope, {key => value})
      end.map(&:predicate).reduce(&:merge)
    end
    
    def sort_predicate
      # todo : call ::JsonApiFilter::Sorter
      scope.all
    end
    
    def search_predicate
      # todo : call ::JsonApiFilter::Searcher
      scope.all
    end
    
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