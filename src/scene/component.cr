
require "crsfml"


module Shadow

	### Base class for all node's components.
	###
	### Typical call order of the methods :
	###  - `enter_tree`
	###  - `ready`
	###  - Each frame :
	###    - `event` (if any)
	###    - `unhandled_event` (if any)
	###    - `all_event` (if any)
	###    - `pre_update`
	###    - `update`
	###    - `post_update`
	###    - `pre_render`
	###    - `render`
	###    - `post_render`
	###    - `late_update`
	###  - `exit_tree`
	###
	### This order is only relative to the current component.
	### For a more detailed order (including node's children), see the
	### `Shadow::Node` class.
	###
	abstract class Component

		macro inherited

			### Unique symbol for {{@type.name.id}}.
			###
			def self.symbol
				:{{ @type.name.gsub(/:/, "_").id }}
			end


			class ::Shadow::ComponentCollection < Hash(Symbol, ::Shadow::Component)

				### Gets the component of type {{@type.name.id}}.
				###
				def []( k : {{@type}}.class )
					self[ k.symbol ]
				end

				### Gets the component of type {{@type.name.id}}
				###
				def []?( k : {{@type}}.class )
					self[ k.symbol ]?
				end

				### Deletes the component of type {{@type.name.id}}
				###
				def delete( k : {{@type}}.class )
					delete k.symbol
				end

			end # ::Shadow::ComponentCollection

			class ::Shadow::Node

				### Gets the component of type {{@type.name.id}}.
				###
				def component( k : {{@type}}.class )
					@components[ k.symbol ]
				end

				### Gets the component of type {{@type.name.id}}.
				###
				def component?( k : {{@type}}.class )
					@components[ k.symbol ]?
				end

				### Checks if the node has the component of type
				### {{@type.name.id}}.
				###
				def has_component?( k : {{@type}}.class )
					!@components[ k.symbol ]?.nil?
				end

				### Deletes the component of type {{@type.name.id}}.
				###
				def delete( k : {{@type}}.class )
					@components.delete k.symbol
				end

			end # ::Shadow::Node

		end # macro inherited




		### Checks if the component has been initialized (`ready` method
		### called).
		###
		getter? is_ready : Bool




		### Initializes a new instance.
		###
		### This function should be use for initialization, not asset or
		### data loading (use `ready` for this).
		###
		def initialize
			@is_ready = false
		end




		### Method called when the component enters the tree (can be called
		### multiple time).
		###
		def enter_scene
		end

		### Method called when the component exits the tree (can be called
		### multiple time).
		###
		def exit_scene
		end

		### Method called when the component is ready (called after the first
		### `enter_tree` call).
		###
		def ready
			@is_ready = true
		end




		### Method called for handling the given event. Once the event is
		### flagged as "handled", this method isn't called.
		###
		### This method returns `true` for flagging the event as handled.
		###
		def event( ev : SF::Event ) : Bool
			false
		end

		### Method called for handling the given event. This method is called
		### for all events, even handled one.
		###
		def all_event( ev : SF::Event )
		end

		### Method called for handling the given event. This method is called
		### only for unhandled events.
		###
		def unhandled_event( ev : SF::Event )
		end




		### Called before the `update` methods (including child nodes and
		### components).
		###
		def pre_update( dt : SF::Time )
		end

		### Called for updating the component.
		### It is called after all children node's `update`.
		def update( dt : SF::Time )
		end

		### Called after the `update` methods.
		###
		def post_update( dt : SF::Time )
		end

		### Called after all render methods.
		###
		def late_update( dt : SF::Time )
		end




		### Called before the `render` methods (including child nodes and
		### components).
		###
		### It returns the new render target and the new render states. This
		### way, it's possible to implement camera, viewport, etc.
		###
		def pre_render( target : SF::RenderTarget, state : SF::RenderStates )
			{ target, state }
		end

		### Called for rendering the component.
		###
		def render( target : SF::RenderTarget, state : SF::RenderStates )
		end

		### Called after the render methods.
		###
		def post_render( target : SF::RenderTarget, state : SF::RenderStates )
		end


	end # class Component

end # module Shadow

