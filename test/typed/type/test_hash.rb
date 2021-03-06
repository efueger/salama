require_relative "../helper"

class TypeHash < MiniTest::Test

  def setup
    @types = Register.machine.boot.space.types
    @first = @types.values.first
  end

  def test_hash
    assert_equal Parfait::Dictionary , @types.class
  end

  def test_length
    assert @types.length > 16
  end

  def test_two_hashs_not_equal
    assert @types.keys.last != @types.keys.first
  end

  def test_name
    assert_equal "Word_Type" , @types.values.first.name
  end

  def test_to_hash
    hash = @first.to_hash
    assert_equal hash[:type] , :Word
    assert_equal hash[:char_length] , :Integer
    assert_equal 2 , @first.instance_length
  end

  def test_hashcode_with_hash
    assert_equal @first.hash , Parfait::Type.hash_code_for( @first.to_hash)
  end

  def test_second_hash_different
    hash2 = @first.to_hash
    hash2[:random] = :Type
    assert @first.hash != Parfait::Type.hash_code_for( hash2 )
  end

  def test_add_is_different
    type = @first.add_instance_variable :random , :Integer
    assert type != @first , "new: #{type.inspect} , old: #{@first.inspect}"
    assert @first.hash != type.hash
  end

end
