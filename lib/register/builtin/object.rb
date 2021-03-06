require_relative "compile_helper"

module Register
  module Builtin
    class Object
      module ClassMethods
        include CompileHelper

        # self[index] basically. Index is the first arg
        # return is stored in return_value
        # (this method returns a new method off course, like all builtin)
        def get_internal_word context
          compiler = compiler_for(:Object , :get_internal_word )
          source = "get_internal_word"
          me , index = self_and_arg(compiler,source)
          # reduce me to me[index]
          compiler.add_code  GetSlot.new( source , me , index , me)
          # and put it back into the return value
          compiler.add_code Register.set_slot( source , me , :message , :return_value)
          return compiler.method
        end

        # self[index] = val basically. Index is the first arg , value the second
        # no return
        def set_internal_word context
          compiler = compiler_for(:Object , :set_internal_word , {:value => :Object} )
          source = "set_internal_word"
          me , index = self_and_arg(compiler,source)
          value = do_load(compiler,source)

          # do the set
          compiler.add_code SetSlot.new( source , value , me , index)
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end
