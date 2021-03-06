require_relative "../helper"

class TestMessage < MiniTest::Test

  def setup
    @mess = Register.machine.boot.space.first_message
  end

  def test_length
    assert_equal 9 , @mess.get_type.instance_length , @mess.get_type.inspect
    assert_equal 9 , Parfait::Message.get_length_index
  end

  def test_attribute_set
    @mess.receiver = 55
    assert_equal 55 , @mess.receiver
  end

  def test_indexed
    assert_equal 9 , @mess.get_type.variable_index(:indexed_length)
  end
  def test_push1
    @mess.push :name
    assert_equal 1 , @mess.get_length
  end
  def test_push2
    @mess.push :name
    assert_equal 1 , @mess.indexed_length
  end
  def test_push3
    @mess.push :name
    assert_equal 1 , @mess.get_internal_word(9)
  end
  def test_get_internal_word
    @mess.push :name
    assert_equal :name , @mess.get_internal_word(10)
  end

  def test_get
    index = @mess.push :name
    assert_equal 1 , index
    assert_equal :name , @mess.get(1)
  end

  def test_each
    three = [:one,:two,:three]
    three.each {|i| @mess.push(i)}
    assert_equal 3 , @mess.get_length
    @mess.each do |u|
      assert_equal u , three.delete(u)
    end
    assert_equal 0 , three.length
  end

end
