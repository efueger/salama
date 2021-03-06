require_relative "../helper"

class HelloTest < MiniTest::Test
  include AST::Sexp

  def check
    machine = Register.machine.boot
    Typed.compile( @input )
    machine.collect
    machine.translate_arm
    writer = Elf::ObjectWriter.new
    writer.save "test/hello.o"
  end

  def test_string_put
    @input = s(:statements, s(:return, s(:call, s(:name, :putstring), s(:arguments),
                  s(:receiver, s(:string, "Hello again\\n")))))
    check
  end
end
