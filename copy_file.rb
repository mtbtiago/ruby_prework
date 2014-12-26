puts "Enter source file name"
source_fn = gets.chomp
puts "Enter target file name"
target_fn = gets.chomp
source = IO.read(source_fn)
IO.write(target_fn,source)
