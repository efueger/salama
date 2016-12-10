require_relative 'helper'

module Register
class TestCallStatement #< MiniTest::Test
  include Statements

  def test_call_constant_int
    @input = <<HERE
class Integer
  int putint()
    return 1
  end
end
class Space
  int main()
    42.putint()
  end
end
HERE
    @expect =  [Label, GetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
               GetSlot, GetSlot, Label, FunctionReturn]
    check
  end


  def test_call_constant_string
    @input = <<HERE
class Word
  int putstring()
    return 1
  end
end
class Space
  int main()
    "Hello".putstring()
  end
end
HERE
    @expect =  [Label, GetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
               GetSlot, GetSlot, Label, FunctionReturn]
    check
  end

  def test_call_local_int
    @input = <<HERE
class Integer
  int putint()
    return 1
  end
end
class Space
  int main()
    int testi = 20
    testi.putint()
  end
end
HERE
    @expect = [Label, LoadConstant, GetSlot, SetSlot, GetSlot, GetSlot, GetSlot ,
               SetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot ,
               RegisterTransfer, FunctionCall, Label, RegisterTransfer, GetSlot, GetSlot, Label ,
               FunctionReturn]
  check
  end

  def test_call_local_class
    @input = <<HERE
class List < Object
  int add()
    return 1
  end
end
class Space
  int main()
    List test_l
    test_l.add()
  end
end
HERE
    @expect = [Label, GetSlot, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot ,
               LoadConstant, SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label ,
               RegisterTransfer, GetSlot, GetSlot, Label, FunctionReturn]
  check
  end

  def test_call_puts
    @input    = <<HERE
class Space
int puts(Word str)
  return str
end
int main()
  puts("Hello")
end
end
HERE
    @expect = [Label, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall ,
               Label, RegisterTransfer, GetSlot, GetSlot, Label, FunctionReturn]
    was = check
    set = was.next(7)
    assert_equal SetSlot , set.class
    assert_equal 9, set.index , "Set to message must be offset, not #{set.index}"
  end
end
end