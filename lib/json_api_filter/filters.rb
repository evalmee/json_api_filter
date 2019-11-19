module JsonApiFilter
  class Filters
    attr_reader :allowed_filters, :params

    def initialize(allowed_filters, params)
      @allowed_filters = allowed_filters
      @params = params
    end

    def to_hash
      filters.inject(:merge)
    end

    private

    def filters
      allowed_filters.map do |attr|
        value = params.fetch(:filter, {}).fetch(attr, "")
        ::JsonApiFilter::FilterBy.new(attr, value).to_hash
      end
    end
  end
end

