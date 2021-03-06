require 'date'

SATURDAY = 6
AMOUNT_TRESHOLD = 5
AMOUNT_DISCOUNT = 5
WEEKEND_DISCOUNT = 10
HOUSEWARE_DISCOUNT = 5
STR_YOUR_INVOICE = "Your invoice"
STR_WELLCOME = "Welcome to Shopping REPL"

class ShoppingCartUtils
	def self.isWeekend
		Date.today.cwday >= SATURDAY
	end

	def self.calcDiscount(gross, discount)
		 base = gross - (gross * discount / 100)
		 discounts = gross - base
		 return base, discounts
	end

	def self.formatCurr(value)
		return "$#{"%#10.2f" % value.round(2)}"
	end

	def self.formatDescCurr(desc, curr)
		return "#{"%-20s" % desc}: #{formatCurr(curr)}"
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
		s = 
			"Available items:\n"+
			"%-2s" % "ID"+" "+"%-20s" % "Name"+" "+"%-11s" % "Price"+"\n"+
			"=" * 2+" "+"=" * 20 +" "+"=" * 11 +"\n"
		@items.each{|key, value|
			s = s + 
				"%2d" % key+" "+"%-20s" % value.name+" "+
				 ShoppingCartUtils.formatCurr(value.price)+"\n"
		}
		return s
	end

	def existsID(id)
		return @items.has_key?(id)
	end
end

class ShoppingCart
	attr_reader :items
	attr_reader :total

	def initialize
		clear
	end

	def clear
		@items = []
		@total = 0
	end

	def calculate
		@total = 0.0
		itemDiscounts = 0.0
		footerDiscount = 0.0
		items.each{|item| 
      _total, _discounts = item.calculate
      @total = @total + _total
      itemDiscounts = itemDiscounts + _discounts
		}
		if items.count >= AMOUNT_TRESHOLD
			@total, footerDiscount = ShoppingCartUtils.calcDiscount(@total,AMOUNT_DISCOUNT)
		end
		itemDiscounts = itemDiscounts + footerDiscount
		return @total + itemDiscounts, itemDiscounts, @total 
	end

	def addItem(item,count = 1)
		count.times {@items << item}
		calculate
	end

	def contents
		s = "Your cart has #{@items.count} items\n"
		@items.each{|item| 
			_base, _discount = item.calculate
			s = s + 
				"Name:#{item.name}. "+
				"Unit Price: #{ShoppingCartUtils.formatCurr(item.price)}. "+
				"Unit Total: #{ShoppingCartUtils.formatCurr(_base)}\n"}
		return s
	end

	def invoice
		_gross, _discounts, _total = calculate
		s = 
			STR_YOUR_INVOICE+"\n"+
			"=" * STR_YOUR_INVOICE.length+"\n"+
			contents+
			ShoppingCartUtils.formatDescCurr('Subtotal',_gross)+"\n"+
			ShoppingCartUtils.formatDescCurr('Discounts',_discounts)+"\n"+
			ShoppingCartUtils.formatDescCurr('Total',_total)+"\n"
		return s
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
  		return WEEKEND_DISCOUNT
  	else
  		return super
  	end
  end
end

class HouseWareItem < Item
  def discount
  	if @price > 100
  		return HOUSEWARE_DISCOUNT
  	else
  		return super
  	end
  end
end

class REPL
	def initialize
		@shopping_cart = ShoppingCart.new
		@availableItems = ShoppingCartItems.new
		@availableItems.registerItem(FruitItem.new("Bananas",10.0))
		@availableItems.registerItem(Item.new("Orange juice",10.0))
		@availableItems.registerItem(Item.new("Rice",1.0))
		@availableItems.registerItem(HouseWareItem.new("Vacuum cleaner",150.0))
		@availableItems.registerItem(Item.new("Anchovies",2.0))
	end
	
	def showHelp
		s = 
			"\nPlease select:\n"+
			"0    => check out\n"+
			"a    => list available items\n" + 
			"t    => print current total\n"+
			"i    => print detailed invoice\n"+
			"c    => clear shopping cart\n"+
 			"<ID> => add item to cart\n" +
			"s    => show cart contents\n"+
			"h    => this help\n"
		return s
	end
	
	def execute
		@shopping_cart.clear
		puts "=" * STR_WELLCOME.length
		puts STR_WELLCOME
		puts "=" * STR_WELLCOME.length
		puts @availableItems.showAvailableItems;
		puts showHelp
		begin
			puts "\nPlease entry your choice. Press 'h' for help."
			c = gets.chomp
			case c
			when '0'
				break
			when 'a'
				puts @availableItems.showAvailableItems;
			when 't'
				puts "Your current total is #{@shopping_cart.total}"
			when 'i'
				puts @shopping_cart.invoice
			when 'c'
				@shopping_cart.clear
				puts @shopping_cart.contents
			when 's'
				puts @shopping_cart.contents
			when 'h'
				puts showHelp
			else
				id = c.to_i
				if @availableItems.existsID(id)
					puts "Enter quantity"
					q = gets.chomp.to_i
					@shopping_cart.addItem(@availableItems.items[id],q)
 					puts @shopping_cart.contents
				else
					puts "Sorry, we haven't this item"
				end
			end
		end while c != '0'
		puts @shopping_cart.invoice
	end
end

################################
#            main              
################################
repl = REPL.new
repl.execute
