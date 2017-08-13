
require "crsfml"
require "./component-collection.cr"


module Shadow

	class Node
		include Iterable(Node)
		include Enumerable(Node)



		@parent : Node|Nil



		### Gets the list of components.
		###
		getter components : ComponentCollection
		### Gets the list of child nodes.
		###
		getter children : Array(Node)




		### Initalizes a new instance.
		###
		def initialize
			@parent = nil
			@components = ComponentCollection.new
			@children = Array(Node).new
		end




		### Enumerates the child nodes.
		###
		def each( &block )
			@children.each do |node|
				yield node
			end
		end

		### Returns an iterator over the child nodes.
		###
		def each
			@children.each
		end

		### Enumerates the components.
		###
		def each_component( &block )
			@components.each do |k, comp|
				yield comp
			end
		end

		### Returns an iterator over the child nodes.
		###
		def each_component
			@components.each
		end




		### Gets the component which has the given symbol.
		###
		def component( comp : Symbol )
			@components[ comp ]
		end

		### Gets the component which has the given symbol.
		###
		def component?( comp : Symbol )
			@components[ comp ]?
		end

		### Checks if the node has the given component.
		###
		def has_component?( comp : Symbol )
			!@components[ comp ]?.nil?
		end




		### Adds a new component in the node.
		###
		def <<( c : Component )
			@components << c
			self
		end

		### Deletes the component with the given symbol from the node.
		###
		def delete( comp : Symbol )
			@components.delete comp
		end




		### Checks if the node is in a scene.
		###
		def in_scene? : Bool
			!@parent.nil? && parent.in_scene?
		end

		### Gets the scene.
		###
		def scene
			parent.scene
		end

		### Gets the scene.
		###
		def scene?
			if !@parent.nil?
				@parent.scene?
			else
				nil
			end
		end




		### Gets the parent.
		###
		def parent?
			@parent
		end

		### Checks if the node has a parent.
		###
		def has_parent?
			!@parent.nil?
		end

		### Gets the parent.
		###
		def parent
			@parent.not_nil!
		end

		### Defines the parent.
		###
		def parent=( n : Node|Nil )
			if n == self
				raise ArgumentError.new "Trying to create a cyclic reference."
			end

			if !@parent.nil?
				@parent.delete self
				@parent = nil
			end

			if !n.nil?
				n << self
			end

			n
		end

		### Defines the parent.
		###
		protected def raw_parent=( n : Node )
			@parent = n
		end




		### Adds a node.
		###
		def <<( n : Node )
			if n == self
				raise ArgumentError.new "Trying to create a cyclic reference."
			end

			if n.has_parent?
				n.parent.delete n
			end

			n.raw_parent = self
			if in_scene?
				n.enter_scene
			end

			@children << n

			self
		end

		### Deletes a node.
		###
		def delete( n : Node )
			idx = @children.index n

			if idx.nil?
				raise ArgumentError.new "'#{n}' isn't in the actual node."
			end

			if in_scene?
				n.exit_scene
			end

			@children.delete_at idx

			self
		end




		### Called when the node enters the scene.
		###
		def enter_scene : Void
			each_component &.enter_scene
			each &.enter_scene

			if !@is_ready
				ready
				@is_ready = true
			end
		end

		### Called when the node exits the scene.
		###
		def exit_scene : Void
			each &.exit_scene
			each_component &.exit_scene
		end

		### Called once, just after the first `enter_scene` call.
		###
		def ready
			return if @is_ready
			each_component &.ready
		end



		### Called for handling the given event.
		###
		def event( ev : SF::Event ) : Bool
			handled = false

			each do |node|
				handled = node.event( ev )
				break if handled
			end

			return true if handled

			each_component do |comp|
				handled = comp.event( ev )
				break if handled
			end

			handled
		end

		### Called for handling the given unhandled event.
		###
		def unhandled_event( ev : SF::Event )
			each &.unhandled_event ev
			each_component &.unhandled_event ev
		end



		### Called before the update.
		###
		def pre_update( dt : SF::Time )
			each_component &.pre_update dt
		end

		### Called for updating the node, its component and its children.
		###
		def update( dt : SF::Time )
			each do |node|
				node.pre_update dt
				node.update dt
				node.post_update dt
			end
			each_component &.update dt
		end

		### Called after the update.
		###
		def post_update( dt : SF::Time )
			each_component &.post_update dt
		end

		### Called after all render methods.
		###
		def late_update( dt : SF::Time )
			each &.late_update dt
			each_component &.late_update dt
		end



		### Called before the render. Useful for modifying the render target &
		### states.
		###
		def pre_render( target : SF::RenderTarget, state : SF::RenderStates )
			each_component do |comp|
				target, state = comp.pre_render target, state
			end
			{ target, state }
		end

		### Called for rendering the node's components and children.
		###
		def render( target : SF::RenderTarget, state : SF::RenderStates )
			each_component &.render target, state
			each do |node|
				t, s = node.pre_render target, state
				node.render t, s
				node.post_render t, s
			end
		end

		### Called after the render.
		###
		def post_render( target : SF::RenderTarget, state : SF::RenderStates )
			each_component &.post_render target, state
		end


	end # class Node

end # module Shadow
