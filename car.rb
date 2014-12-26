class Car
	@@total = 0
	attr_accessor :color

	def initialize(color)
		@color = color
		@@total = @@total + 1
	end

	def honk
		puts "Beeeep!"
	end

	def print_color
		puts @color
	end

	def self.total
		puts "So far we've got #{@@total} cars"
	end
end

my_car = Car.new "red"
other_car = Car.new "grey"
my_car.color = "green"

my_car.print_color
other_car.print_color
Car.total