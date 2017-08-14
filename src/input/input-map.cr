
require "./input-axis.cr"


module Shadow

	abstract class InputMap


		@@map : Hash(Symbol, InputAxis) = Hash(Symbol, InputAxis).new



		def self.[]( axis : Symbol )
			@@map[ axis ]
		end

		def self.[]?( axis : Symbol )
			@@map[ axis ]?
		end

		def self.[]=( axis : Symbol, input : InputAxis )
			@@map[ axis ] = input
		end



		def self.value( axis : Symbol )
			@@map[ axis ].value
		end

		def self.value( x : Symbol, y : Symbol )
			SF::Vector2f.new value(x), value(y)
		end


		def self.update( dt : SF::Time )
			@@map.each do |_, axis|
				axis.update dt
			end
		end

	end

end

