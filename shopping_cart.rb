require 'date'

class ShoppingCartUtils
	def self.isWeekend
		Date.today.cwday >= 6
	end

	def self.calcDiscount(gross, discount)
		 base = gross - (gross * discount / 100)
		 discounts = gross - base
		 return base, discounts
	end
end

class ShoppingCartItems
	attr_reader :items

	def initialize
		@itemID = 0
		@items = {}
	end

	def registerItem(item)
		@itemID = @itemID + 1;
		@items[@itemID] = item
	end

	def showAvailableItems
		s = "Available items:\n"
		@items.each{|key, value|
			s = s + "#{key}. #{value.name}: Price: #{value.price}€\n"
		}
		return s
	end

	def existsID(id)
		return @items.has_key?(id)
	end
end

class ShoppingCart
	attr_reader :items

	def initialize
		clear
	end

	def clear
		@items = []
	end

	def calculate
		base = 0.0
		itemDiscounts = 0.0
		footerDiscount = 0.0
		items.each{|item| 
      _base, _discounts = item.calculate
      base = base + _base
      itemDiscounts = itemDiscounts + _discounts
		}
		if items.count >= 5
			base, footerDiscount = ShoppingCartUtils.calcDiscount(base,5)
		end
		itemDiscounts = itemDiscounts + footerDiscount
		return base + itemDiscounts, itemDiscounts, base 
	end

	def addItem(item,count)
		count.times {@items << item}
	end
end

class Item
	attr_accessor :price
	attr_reader :name
	def initialize(name, price)
		@name = name
		@price = price
	end

	def discount 
		return 0.0
	end

	def calculate
		if discount == 0 
			return @price, 0.0
		else
			return ShoppingCartUtils.calcDiscount(@price,discount)
		end
	end
end

class FruitItem < Item
  def discount
  	if ShoppingCartUtils.isWeekend 
  		return 10.0
  	else
  		return super
  	end
  end
end

class HouseWareItem < Item
  def discount
  	if @price > 100
  		return 5.0
  	else
  		return super
  	end
  end
end

################################
#            main              
################################
shopping_cart = ShoppingCart.new
availableItems = ShoppingCartItems.new
availableItems.registerItem(FruitItem.new("Bananas",10.0))
availableItems.registerItem(Item.new("Orange juice",10.0))
availableItems.registerItem(Item.new("Rice",1.0))
availableItems.registerItem(HouseWareItem.new("Vacuum cleaner",150.0))
availableItems.registerItem(Item.new("Anchovies",2.0))

################################
# start shopping
################################
shopping_cart.clear
print availableItems.showAvailableItems;
begin
	puts "\nEnter your choice code. Zero for ending"
	id = gets.chomp.to_i
	if id == 0 
		break
	end
	if availableItems.existsID(id)
		puts "Enter quantity"
		q = gets.chomp.to_i
		shopping_cart.addItem(availableItems.items[id],q)
	else
		puts "Sorry, we haven't this item"
	end
end while id != 0

# Show totals
gross, discounts, total = shopping_cart.calculate
puts "Your shopping cart:"
puts "Gross #{gross}"
puts "Discounts #{discounts}"
puts "Total #{total}"