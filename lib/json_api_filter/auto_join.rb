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
      scope.joins(association_name.to_sym)
    end
    
  end
end
