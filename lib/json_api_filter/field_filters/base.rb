module JsonApiFilter
  module FieldFilters
    class Base
      
      attr_reader :scope, :values, :association

      # @param [ActiveRecord::Base] scope
      # @param [Hash] values
      # @param [Boolean] association
      def initialize(scope, values, association: false )
        @scope = scope
        @values = values
        @association = association
      end
    
    end
  end
end
