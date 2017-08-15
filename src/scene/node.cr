
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

		### Enumerates on all the node's parent (to the scene root).
		###
		def each_parent( &block )
			p = self
			while p = p.parent?
				yield p
			end
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



		### Gets the first component corresponding to `s` in the ancestry.
		###
		def first_in_ancestry( s )
			comp = nil
			each_parent do |p|
				if p.has_component? s
					comp = p.component s
					break
				end
			end
			comp
		end

		### Gets the first component corresponding to `s` in the children.
		###
		### If `shallow` is `false`, then the methods will seach recursivly.
		###
		def first_in_children( s, *, shallow = true )
			comp = nil
			each do |child|
				if child.has_component? s
					comp = child.component s
					break
				end
			end

			if comp.nil? && !shallow
				each do |child|
					comp = child.first_in_children s
					break if !comp.nil?
				end
			end

			comp
		end

		### Gets all the components corresponding to the given symbol in the
		### ancestry.
		###
		def all_in_ancestry( s : Symbol )
			arr = [] of Component
			each_parent do |p|
				if p.has_component? s
					arr << p.component s
				end
			end
			arr
		end

		### Gets all components corresponding to the given symbol in the
		### children. If `shallow` is `false`, the method will search
		### recursivly.
		###
		def all_in_children( s : Symbol, *, shallow = true )
			arr = [] of Component
			each do |child|
				if shallow
					if child.has_component? s
						arr << arr.component s
					end
				else
					arr += child.all_in_children s, shallow: false
				end
			end
			arr
		end

		### Gets all components of the given type in the ancestry.
		###
		def all_in_ancestry( klass : T.class ) forall T
			arr = [] of T
			each_parent do |p|
				if p.has_component? klass
					arr << p.component( klass ).as T
				end
			end
			arr
		end

		### Gets all components of the given type in the children. If `shallow`
		### is `false`, the method will search recursivly.
		###
		def all_in_children( klass : T.class, *, shallow = true ) forall T
			arr = [] of T
			each do |child|
				if shallow
					if child.has_component? klass
						arr << child.component( klass ).as T
					end
				else
					arr += child.all_in_children klass, shallow: false
				end
			end
			arr
		end




		### Adds a new component in the node.
		###
		def <<( c : Component )
			@components << c
			c.node = self
			self
		end

		### Deletes the component with the given symbol from the node.
		###
		def delete( comp : Symbol )
			comp = @components.delete comp
			comp.node = nil
			self
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



		### Gets the viewport of the current node.
		###
		def viewport
			first_in_ancestry Components::Viewport
		end



		### Gets the application.
		###
		def application
			scene.application
		end

		### Gets the application.
		###
		def application?
			return nil if scene?.nil?
			scene.application?
		end

		### Checks if the application is present.
		###
		def has_application?
			scene.has_application?
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
