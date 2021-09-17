require "json_api_filter/version"
require "json_api_filter/auto_join"
require "json_api_filter/dispatch"
require "json_api_filter/filter_attributes"
require "json_api_filter/value_parser"
require "json_api_filter/field_filters/base"
require "json_api_filter/field_filters/matcher"
require "json_api_filter/field_filters/compare"
require "json_api_filter/field_filters/searcher"
require "json_api_filter/field_filters/sorter"
require "json_api_filter/field_filters/pagination"
require "active_support/concern"
require "active_support/core_ext/object/blank"

module JsonApiFilter
  class MissingPermittedFilterError < ::StandardError
    def message
      "PERMITTED_FILTERS are required"
    end
  end

  class UnknownInclusions < ::StandardError
    attr_reader :item
    def initialize(item)
      super(message)
      @item = item
    end

    def message
      "Unable to identify #{item} as a relationship path or inclusion"
    end
  end

  extend ::ActiveSupport::Concern
  included do
  
    # @param [ActiveRecord::Base] scope
    def json_api_filter(scope, query_params = params)
      unless self.class.json_api_permitted_filters.present?
        raise ::JsonApiFilter::MissingPermittedFilterError
      end

      ::JsonApiFilter::Dispatch.new(
        scope,
        query_params,
        allowed_filters: self.class.json_api_permitted_filters,
        allowed_searches: self.class.json_api_permitted_searches
      ).process
    end

    def json_api_inclusions(params)
      inclusions_params = params.fetch(:include, "").split(",").map(&:to_sym).uniq
      unknown_inclusion = inclusions_params.find { |resource| json_api_permitted_inclusions.exclude?(resource) }
      raise UnknownInclusions.new(unknown_inclusion) if unknown_inclusion.present?
      inclusions_params
    end

    def self.permitted_filters(val)
      define_singleton_method(:json_api_permitted_filters) do
        val
      end
    end

    def self.json_api_permitted_filters
      []
    end

    def self.permitted_searches(global, **columns)
      define_singleton_method(:json_api_permitted_searches) do
        { global: global, columns: columns }
      end
    end

    def self.json_api_permitted_searches
      {}
    end

    def self.permitted_inclusions(inclusions)
      define_singleton_method(:json_api_permitted_inclusions) do
        inclusions
      end
    end

    def self.json_api_permitted_inclusions
      []
    end

    def json_api_permitted_inclusions
      self.class.json_api_permitted_inclusions
    end
  end
end
