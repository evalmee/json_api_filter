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
        allowed_filters.include?(k.to_s)
      end
    end
  end
end

