module JsonApiFilter
  class Dispatch
  
    attr_reader :params, :scope, :allowed_filters
    
    # @param [ActiveRecord::Base] scope
    # @param [Hash, ActionController::Parameters] params
    # @param [Array<Symbol>] allowed_filters
    def initialize(scope, params, allowed_filters:)
      @params = params
      @scope = scope
      @allowed_filters = allowed_filters
    end

    # @return [ActiveRecord_Relation]
    def process
      [
        scope,
        filters_predicate,
        sort_predicate,
        search_predicate,
      ].compact.reduce(&:merge)
    end
    
    private
    
    # @return [ActiveRecord::Base, NilClass]
    def filters_predicate
      #todo : .with_indifferent_access add a dependency to ActiveSupport => to remove
      parser_params.fetch('filter',[]).map do |key, value|
        if value.class != ActiveSupport::HashWithIndifferentAccess
          next ::JsonApiFilter::FieldFilters::Matcher.new(scope, {key => value})
        end
        ::JsonApiFilter::FieldFilters::Compare.new(scope, {key => value})
      end.map(&:predicate).reduce(&:merge)
    end

    # @return [ActiveRecord::Base, NilClass]
    def sort_predicate
      # todo : call ::JsonApiFilter::Sorter
      scope.all
    end

    # @return [ActiveRecord::Base, NilClass]
    def search_predicate
      # todo : call ::JsonApiFilter::Searcher
      scope.all
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