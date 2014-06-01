module Ast
  class ModuleExpression < Expression
    attr_reader  :name ,:expressions
    def initialize name , expressions
      @name = name.to_sym
      @expressions = expressions
    end
    def inspect
      self.class.name + ".new(" + @name.inspect + " ," + @expressions.inspect + " )"  
    end
    def to_s
      "module #{name}\n #{expressions}\nend\n"
    end
    def attributes
      [:name , :expressions]
    end
    def compile context , into
      clazz = context.object_space.get_or_create_class name
      context.current_class = clazz
      expressions.each do |expression|
        # check if it's a function definition and add
        # if not, execute it, but that does means we should be in crystal (executable), not ruby. ie throw an error for now
        raise "only functions for now #{expression.inspect}" unless expression.is_a? Ast::FunctionExpression
        expression_value = expression.compile(context , nil )
        puts "compiled return expression #{expression_value.inspect}, now return in 7"
      end

      return nil
    end
  end

  class ClassExpression < ModuleExpression

  end
end