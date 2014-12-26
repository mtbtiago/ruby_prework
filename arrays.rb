def dup(char,len)
	s = ""
	len.times do
		s = s+char
	end
	return s
end

numbers = ["One",2,"Three"]

puts numbers

puts dup("-",40)
for element in numbers
	puts "-> #{element}"
end

#better
puts dup("-",40)
numbers.each do |element|
	puts "--> #{element}"
end

puts dup("-",40)
my_array = []
my_array << "A"
my_array.push "B"
my_array.push "C"
puts my_array

puts dup '-',40
my_array.delete_at 2
puts my_array