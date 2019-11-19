require "json_api_filter/version"
require "json_api_filter/filters"
require "json_api_filter/filter_by"
require "active_support/concern"
require "active_support/core_ext/object/blank"

module JsonApiFilter
  class MissingPermittedFilterError < ::StandardError
    def message
      "PERMITTED_FILTERS are required"
    end
  end

  extend ::ActiveSupport::Concern
  included do

    def filter_by_attr(params = params)
      unless self.class.json_api_permitted_filters.present?
        raise ::JsonApiFilter::MissingPermittedFilterError
      end

      ::JsonApiFilter::Filters.new(
        self.class.json_api_permitted_filters,
        params
      ).to_hash
    end

    def self.permitted_filters(val)
      define_singleton_method(:json_api_permitted_filters) do
        val
      end
    end

    def self.json_api_permitted_filters
      []
    end
  end
end
