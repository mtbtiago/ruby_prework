file_contents = IO.read("puts_vs_print.rb")
puts "Source file contains:\n#{file_contents}"

puts "What's your name?"
name = gets.chomp
IO.write('name.txt',"#{name}\n")