SHIFT = -3
STR1 = 'HAVE A NICE DAY!'

class CaesarCipher
	def initialize
		@alphabet = 0.chr..255.chr
		@MIN = @alphabet.min.ord
		@MAX = @alphabet.max.ord
	end
	private
		def getChar(int)
			i = int
			if i < @MIN
				i = @MAX - (@MIN - i - 1)
			elsif i > @MAX
				i = @MIN + (i - @MAX - 1)
			end
			return i.chr
		end
	public
		def cipher(str,shift = SHIFT)
			result = ''
			str.each_char {|c|
				result = result + getChar(c.ord + shift)
			}
			return result
		end
		def getCipherAndReverse(str,shift = SHIFT)
			s = cipher(str,shift)
			return [
				"%-10s" % "Input:"+" #{str}",
				"%-10s" % "Output #{SHIFT}:"+" #{s}",
				"%-10s" % "Output #{-SHIFT}:"+" #{cipher(s,-SHIFT)}"
			]
		end
end

################
# main
################
myCipher = CaesarCipher.new
myCipher.getCipherAndReverse(STR1).each{|s| puts s}

begin
	puts "Enter a sentence. Blank line to end"
	input = gets.chomp
	if input.empty?
		break
	else
		myCipher.getCipherAndReverse(input).each{|s| puts s}
	end
end while true