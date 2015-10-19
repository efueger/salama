require_relative 'helper'

module Register
  class TestWhile < MiniTest::Test
    include Statements


    def test_while_mini
      @string_input    = <<HERE
class Object
  int main()
    while_plus(1)
      return 3
    end
  end
end
HERE
      @expect = [[SaveReturn],[LoadConstant,IsZero,LoadConstant,Branch],
                  [],[RegisterTransfer,GetSlot,FunctionReturn]]
      check
    end

    def test_while_assign
      @string_input    = <<HERE
class Object
  int main()
    int n = 5
    while_minus(n > 0)
      n = n - 1
    end
  end
end
HERE
      @expect = [[SaveReturn,LoadConstant,GetSlot,SetSlot],[GetSlot,GetSlot,LoadConstant,OperatorInstruction,
                  IsZero,GetSlot,GetSlot,LoadConstant,OperatorInstruction,GetSlot,SetSlot,Branch],
                  [],[RegisterTransfer,GetSlot,FunctionReturn]]
      check
    end


    def test_while_return
      @string_input    = <<HERE
class Object
  int main()
    int n = 10
    while_notzero( n > 5)
      n = n + 1
      return n
    end
  end
end
HERE
      @expect = [[SaveReturn,LoadConstant,GetSlot,SetSlot],
                 [GetSlot,GetSlot,LoadConstant,OperatorInstruction,IsZero,GetSlot,
                   GetSlot,LoadConstant,OperatorInstruction,GetSlot,SetSlot,GetSlot,
                   GetSlot,Branch] ,
                   [],[RegisterTransfer,GetSlot,FunctionReturn]]
      check
    end
  end
end
