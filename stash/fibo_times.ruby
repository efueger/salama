def fibonaccit(n)
  a = 0
  b = 1
  (n-1).times do
    tmp = a
    a = b
    b = tmp + b
  end
  b
end

#1000000.times {fibonaccit( 30 )}
#10.times {|i| puts fibonaccit(i+90).class}
puts fibonaccit 90
