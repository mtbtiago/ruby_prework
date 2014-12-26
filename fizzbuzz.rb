#build an array 1 to 100
# array = []
# 100.times do |i|
#   array << i+1
# end

# (1..100).each { |i| 
# 	if (i%3 == 0) and (i%5 == 0)
# 		puts "FizzBuzz"
# 	elsif i % 3 == 0
# 		puts "Fizz"
# 	elsif i % 5 == 0
# 		puts "Buzz"
# 	else
# 		puts i
# 	end
#}

divisors = {3 => "Fizz", 5 => "Buzz"}

(1..100).each {|i|
	divisible = false
	divisors.each {|key, value|
		if i%key == 0
			print value; divisible = true
		end
	}
	if divisible
		puts
	else
		puts i
	end
}


