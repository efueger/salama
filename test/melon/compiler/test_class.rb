require_relative "helper"

module Melon
  class TestClass < MiniTest::Test

    def setup
      Register.machine.boot unless Register.machine.booted
    end

    def test_creates_class_without_deriviation
      Compiler.compile "class Testing ; end"
      assert t = Parfait::Space.object_space.get_class_by_name(:Testing) , "No classes created"
      assert_equal :Object , t.super_class_name
    end

    def test_creates_class_with_deriviation
     Compiler.compile  "class Test2 < List ;end"
      assert t = Parfait::Space.object_space.get_class_by_name(:Test2) , "No classes created"
      assert_equal :List , t.super_class_name
    end

    def test_picks_up_an_ivar_name
      Compiler.compile  "class TestIvar < Object ; def meth; return @ivar;end; end"
      itest = Parfait::Space.object_space.get_class_by_name(:TestIvar)
      assert itest.instance_type.instance_names.include?(:ivar) , itest.instance_type.instance_names.inspect
    end

  end
end
