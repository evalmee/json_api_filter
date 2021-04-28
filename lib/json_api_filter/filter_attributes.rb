module JsonApiFilter
  class FilterAttributes
    attr_reader :allowed_filters, :params

    
    # @param [ActiveSupport::HashWithIndifferentAccess, Hash] allowed_filters
    # @param [ActiveSupport::HashWithIndifferentAccess, Hash] params
    def initialize(allowed_filters, params)
      @allowed_filters = allowed_filters
      @params = params
    end
    
    # @return [ActiveSupport::HashWithIndifferentAccess, Hash]
    def process
      params.select do |k,v|
        allowed_filters.include?(k.to_sym) ||
          allowed_filters.include?(k.to_s) ||
          nested_allowed_filter.include?(k.to_sym) ||
          nested_allowed_filter.include?(k.to_s)
      end
    end
    
    # Keys of nested allowed filters
    # only one level of nesting supported
    #
    # @example
    #   for: permitted_filters [:id, :author, :name, users: [:id]]
    #   it returns: :users
    #
    # @return [Array<Symbol>]
    def nested_allowed_filter
      allowed_filters.select{|f| f.class == Hash}.map(&:keys).flatten
    end
  end
end

