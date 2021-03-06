module Register

  # SetSlot moves data into memory from a register.
  # GetSlot moves data into a register from memory.
  # Both use a base memory (a register)

  # This is because that is what cpu's can do. In programming terms this would be accessing
  #  an element in an array, in the case of SetSlot setting the register in the array.

  # btw: to move data between registers, use RegisterTransfer

  class SetSlot < Setter

    # If you had a c array and index offset
    # the instruction would do array[index] = register
    # So SetSlot means the register (first argument) moves to the slot (array and index)

    # def initialize source , register , array , index
    # super
    # end
    # attr_accessor :register , :array , :index

  end

  # Produce a SetSlot instruction.
  # From and to are registers or symbols that can be transformed to a register by resolve_to_register
  # index resolves with resolve_index.
  def self.set_slot source , from , to , index
    from = resolve_to_register from
    index = resolve_index( to , index)
    to = resolve_to_register to
    SetSlot.new( source, from , to , index)
  end

end
