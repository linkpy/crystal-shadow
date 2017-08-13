
require "./component.cr"


module Shadow

	class ComponentCollection < Hash(Symbol, Component)

		### Adds a component in the collection.
		###
		def <<( comp : Component )
			self[ comp.class.symbol ] = comp
			self
		end


	end

end
