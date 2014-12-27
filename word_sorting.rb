class SillyString
	def self.simpleSort(value)
		return value.split(' ').sort
	end

	def self.sortWithNoPuncts(value)
		return value.delete("^A-Za-z ").split.sort
	end

	def self.noCaseSort(value)
		return value.delete("^A-Za-z ").split.sort{|a,b|a.upcase <=> b.upcase}
	end
end

STR1 = 'Have a nice day'
STR2 = 'Fools, fall for foolish: follies.'
STR3 = 'Ruby is a fun language!"'

################
# main
################
puts "1. First, split the array into words and sort it with default sort method."
puts "Input: #{STR1}"
puts "Output: #{SillyString.simpleSort(STR1)}"

puts "2. Now, before splitting the array remove punctuation characters."
puts "Input: #{STR2}"
puts "Output: #{SillyString.sortWithNoPuncts(STR2)}"

puts "3. After that, sort using a custom function that ignores cases when comparing words"
puts "Input: #{STR3}"
puts "Output: #{SillyString.noCaseSort(STR3)}"

begin
	puts "Want to try yourself? [Y/n]"
	c = gets.chomp
	if ['','Y','y'].include?(c)
		puts 'Enter a sentence'
		s = gets.chomp
		puts "Your sentence sorted is #{SillyString.noCaseSort(s)}"
	else
		break
	end
end while true