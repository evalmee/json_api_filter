module JsonApiFilter
  class AutoJoin
  
    attr_reader :association_name, :scope
    
    # @param [ActiveRecord::Base, ActiveRecord_Relation] scope
    # @param [String, Symbol] association_name
    def initialize(scope, association_name)
      @association_name = association_name
      @scope = scope
    end
    
    def predicate
      scope.joins(table_name.to_sym)
    end
    
    private
    
    # @return [ActiveRecord::Base]
    def model_klass
      scope.try(:klass) || scope
    end
    
    def table_name
      model_klass.reflections[association_name.to_s].table_name
    end
    
  
  end
end
