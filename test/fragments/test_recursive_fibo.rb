require_relative 'helper'

class TestRecursinveFibo < MiniTest::Test
  include Fragments

  def test_recursive_fibo
    @string_input = <<HERE
    def fibonaccir( n )
      if n <= 1
        return n 
      else
        res = fibonaccir( n - 1 ) + fibonaccir( n - 2 )
        return res
      end
    end 

    putint(fibonaccir( 10 ))
HERE
    @should = [0x0,0xb0,0xa0,0xe3,0xa,0x10,0xa0,0xe3,0x2,0x0,0x0,0xeb,0x1,0x70,0xa0,0xe3,0x0,0x0,0x0,0xef,0x0,0x70,0xa0,0xe1,0x0,0x40,0x2d,0xe9,0x0,0x20,0xa0,0xe3,0x1,0x30,0xa0,0xe3,0x1,0x0,0x51,0xe3,0x6,0x0,0x0,0xda,0x2,0x40,0xa0,0xe1,0x3,0x20,0xa0,0xe1,0x3,0x50,0x84,0xe0,0x5,0x30,0xa0,0xe1,0x1,0x60,0x41,0xe2,0x6,0x10,0xa0,0xe1,0xf6,0xff,0xff,0xea,0x7e,0x0,0x2d,0xe9,0x3,0x10,0xa0,0xe1,0x12,0x0,0x0,0xeb,0x7e,0x0,0xbd,0xe8,0x0,0x80,0xbd,0xe8,0x0,0x40,0x2d,0xe9,0xa,0x30,0x42,0xe2,0x22,0x21,0x42,0xe0,0x22,0x22,0x82,0xe0,0x22,0x24,0x82,0xe0,0x22,0x28,0x82,0xe0,0xa2,0x21,0xa0,0xe1,0x2,0x41,0x82,0xe0,0x84,0x30,0x53,0xe0,0x1,0x20,0x82,0x52,0xa,0x30,0x83,0x42,0x30,0x30,0x83,0xe2,0x0,0x30,0xc1,0xe5,0x1,0x10,0x41,0xe2,0x0,0x0,0x52,0xe3,0xef,0xff,0xff,0x1b,0x0,0x80,0xbd,0xe8,0x0,0x40,0x2d,0xe9,0x1,0x20,0xa0,0xe1,0x20,0x10,0x8f,0xe2,0x9,0x10,0x81,0xe2,0xe9,0xff,0xff,0xeb,0x14,0x10,0x8f,0xe2,0xc,0x20,0xa0,0xe3,0x1,0x0,0xa0,0xe3,0x4,0x70,0xa0,0xe3,0x0,0x0,0x0,0xef,0x0,0x70,0xa0,0xe1,0x0,0x80,0xbd,0xe8,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0]
    parse 
    write "recursive_fibo"
  end
end
