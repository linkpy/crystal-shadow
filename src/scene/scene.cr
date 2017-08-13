
require "crsfml"
require "./node.cr"



module Shadow


	### Root of the scene tree.
	###
	class Scene < Node
		include SF::Drawable



		### Initialize a new instance.
		###
		def initialize
			super
		end



		### Overloading hierachy getters of Node.
		### @{
		def in_scene?
			true
		end

		def scene
			self
		end

		def scene? : Scene|Nil
			self
		end



		def parent?
			nil
		end

		def has_parent?
			false
		end

		def parent
			raise Exception.new "The scene can't have a parent."
		end

		def parent=
			raise Exception.new "The scene can't have a parent."
		end
		### @}
		###



		### Allows to directly draw the scene to a render target.
		###
		def draw( target : SF::RenderTarget, states : SF::RenderStates )
			target, states = pre_render( target, states )
			render( target, states )
			post_render( target, states )
		end

	end # class Scene

end # module Shadow

