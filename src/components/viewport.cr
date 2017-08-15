
require "crsfml"
require "../scene/component.cr"


module Shadow::Components

	### A component for drawing to a specific viewport.
	###
	class Viewport < Shadow::Component

		### Left position of the viewport.
		getter left : Float32
		### Top position of the viewport.
		getter top : Float32
		### Right position of the viewport.
		getter right : Float32
		### Bottom position of the viewport.
		getter bottom : Float32



		### The underlying view.
		getter view : SF::View



		### Initializes a new instance.
		###
		def initialize
			super
			@left = @top = 0f32
			@right = @bottom = 1f32

			@view = SF::View.new
		end





		### Sets the left position of the viewport.
		###
		def left=( f )
			@left = f
			_update_view
			f
		end

		### Sets the top position of the viewport.
		###
		def top=( f )
			@top = f
			_update_view
			f
		end

		### Sets the right position of the viewport.
		###
		def right=( f )
			@right = f
			_update_view
			f
		end

		### Sets the bottom position of the viewport.
		###
		def bottom=( f )
			@bottom = f
			_update_view
			f
		end



		def _update_view
			if node?.nil? || !node.in_scene?
				return
			end

			vp = SF::FloatRect.new( @left, @top, @right-@left, @bottom-@top )
			@view.viewport = vp

			size = SF::Vector2f.new
			mv = node.scene.viewport

			size.x = mv.view.size.x * vp.width
			size.y = mv.view.size.y * vp.height
			@view.size = size
			@view.center = size/2f32
		end



		def enter_scene
			_update_view
		end


		@_old_view : SF::View|Nil

		def pre_render( target : SF::RenderTarget, states : SF::RenderStates )
			@_old_view = target.view
			target.view = @view
			{ target, states }
		end

		def post_render( target : SF::RenderTarget, states : SF::RenderStates )
			target.view = @_old_view.not_nil!
			@_old_view = nil
		end

	end

end

