module Parfait
  # Various classes would derive from array in ruby, ie have indexed variables
  #
  # But for our memory type we need the variable part of an object to be after
  # the fixed, ie the instance variables
  #
  # Just using ruby derivation will not allow us to offset the index, so instead the
  # function will be generated and included to the classes that need them.
  #
  # Basic functionality depends on the offset, and those methods are generated by
  # the offset method that has to be called seperately when including this Module

  module Indexed # marker module
    def self.included(base)
      base.extend(OffsetMethods)
      base.attribute :indexed_length
    end

    # include? means non nil index
    def include?  item
      return index_of(item) != nil
    end

    # index of item, remeber first item has index 1
    # return  nil if no such item
    def index_of item
      max = self.get_length
      #puts "length #{max} #{max.class}"
      counter = 1
      while( counter <= max )
        if( get(counter) == item)
          return counter
        end
        counter = counter + 1
      end
      return nil
    end

    # push means add to the end
    # this automatically grows the List
    def push value
      to = self.get_length + 1
      set( to , value)
      to
    end

    def delete value
      index = index_of value
      return false unless index
      delete_at index
    end

    def delete_at index
      # TODO bounds check
      while(index < self.get_length)
        set( index , get(index + 1))
        index = index + 1
      end
      set_length( self.get_length - 1)
      true
    end

    def first
      return nil if empty?
      get(1)
    end

    def last
      return nil if empty?
      get(get_length())
    end

    def empty?
      self.get_length == 0
    end

    def equal?  other
      # this should call parfait get_class, alas that is not implemented yet
      return false if other.class != self.class
      return false if other.get_length != self.get_length
      index = self.get_length
      while(index > 0)
        return false if other.get(index) != self.get(index)
        index = index - 1
      end
      return true
    end

    # above, correct, implementation causes problems in the machine object space
    # because when a second empty (newly created) list is added, it is not actually
    # added as it exists already. TODO, but hack with below identity function
    def ==   other
      self.object_id == other.object_id
    end

    # word length (padded) is the amount of space taken by the object
    # For your basic object this means the number of instance variables as determined by type
    # This is off course 0 for a list, unless someone squeezed an instance variable in
    # but additionally, the amount of data comes on top.
    # unfortuntely we can't just use super because of the Padding
    def padded_length
      padded_words( get_type().instance_length +  get_length() )
    end

    def each
      index = 1
      while index <= self.get_length
        item = get(index)
        yield item
        index = index + 1
      end
      self
    end

    def each_with_index
      index = 1
      while index <= self.get_length
        item = get(index)
        yield item , index
        index = index + 1
      end
      self
    end

    def each_pair
      index = 1
      while index <= self.get_length
        key = get( index  )
        value = get(index + 1)
        yield key , value
        index = index + 2
      end
      self
    end

    def find
      index = 1
      while index <= self.get_length
        item = get(index)
        return item if yield item
        index = index + 1
      end
      return nil
    end

    def set_length  len
      was = self.get_length
      return if was == len
      if(was < len)
        grow_to len
      else
        shrink_to len
      end
    end

    def inspect
      index = 1
      ret = ""
      while index <= self.get_length
        item = get(index)
        ret += item.inspect
        ret += "," unless index == self.get_length
        index = index + 1
      end
      ret
    end

    module OffsetMethods
      # generate all methods that depend on the (memory) offset
      # These are get/set shrink_to/grow_to
      def offset( offset  )
        offset += 1 # for the attribute we add (indexed_length)

        # define methods on the class that includes.
        # weird syntax, but at least it's possible
        (class << self;self;end).send :define_method , :get_length_index do
          offset
        end
        (class << self;self;end).send :define_method , :get_indexed do |index|
          offset + index
        end
        define_method  :get_offset do
          offset
        end

        define_method :get_length do
          r = get_internal_word( offset ) #one for type
          r.nil? ? 0 : r
        end

        # set the value at index.
        # Lists start from index 1
        define_method  :set do | index , value|
          raise "Only positive indexes #{index}" if index <= 0
          if index > self.get_length
            grow_to(index)
          end
          # start one higher than offset, which is where the length is
          set_internal_word( index + offset, value)
        end

        # set the value at index.
        # Lists start from index 1
        define_method  :get do | index|
          raise "Only positive indexes, #{index}" if index <= 0
          ret = nil
          if(index <= self.get_length)
            # start one higher than offset, which is where the length is
            ret = get_internal_word(index + offset )
          end
          ret
        end

        define_method  :grow_to do | len|
          raise "Only positive lenths, #{len}" if len < 0
          old_length = self.get_length
          return if old_length >= len
#          raise "bounds error at #{len}" if( len + offset > 16 )
          # be nice to use the indexed_length , but that relies on booted space
          set_internal_word( offset  , len) #one for type
        end

        define_method  :shrink_to do | len|
          raise "Only positive lenths, #{len}" if len < 0
          old_length = self.get_length
          return if old_length <= len
          set_internal_word( offset  , len)
        end

      end
    end
  end
end
