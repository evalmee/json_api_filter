require "json_api_filter/version"
require "json_api_filter/dispatch"
require "json_api_filter/filter_attributes"
require "json_api_filter/value_parser"
require "json_api_filter/field_filters/base"
require "json_api_filter/field_filters/matcher"
require "json_api_filter/field_filters/compare"
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
  
    # @param [ActiveRecord::Base] scope
    def attr_filter(scope, query_params = params)
      unless self.class.json_api_permitted_filters.present?
        raise ::JsonApiFilter::MissingPermittedFilterError
      end

      ::JsonApiFilter::Dispatch.new(
        scope,
        query_params,
        allowed_filters: self.class.json_api_permitted_filters
      ).process
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
