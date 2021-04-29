module JsonApiFilter
  module FieldFilters
    class Matcher < Base
  
      # @return [ActiveRecord_Relation]
      def predicate
        
        values.map do |key, value|
          scope.where(
            key_translation(key) => ::JsonApiFilter::ValueParser.parse(value)
          )
        end.reduce(&:merge)
      end
      
      private

      #TODO: move to another class
      def key_translation(key)
        return key unless association
        
        table_name(key)
      end
      
      # @return [ActiveRecord::Base]
      def model_klass
        scope.try(:klass) || scope
      end

      def table_name(association_name)
        model_klass.reflections[association_name.to_s].table_name
      end
    
    end
  end
end
