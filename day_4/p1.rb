require 'pry'

def fails_increase_rule(digits)
  digits.each_cons(2) do |pair|
    return true if pair.first < pair.last
  end

  false
end

def fails_double_rule(digits)
  digits.each_cons(2) do |pair|
    return false if pair.first < pair.second
  end

  true
end

count = 0
(158126..624574).each do |int|
  digits = int.digits
  next if fails_increase_rule(digits)
  next if fails_double_rule(digits)
  count+=1
end

puts count
