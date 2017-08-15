
require "crsfml"
require "./node.cr"
require "./component.cr"
require "./component-collection.cr"


module Shadow

	abstract class Application
	end


	### Root of the scene tree.
	###
	class Scene < Node
		include SF::Drawable



		@application : Application|Nil



		### Initialize a new instance.
		###
		def initialize
			super

			@application = nil

			@viewport = Components::Viewport.new
			self << @viewport
		end



		### Gets the application.
		###
		def application
			@application.not_nil!
		end

		### Gets the application.
		###
		def application?
			@application
		end

		### Checks if the scene has an application.
		###
		def has_application?
			!@application.nil?
		end

		### Defines the application.
		###
		def application=( app : Application|Nil )
			@application = app
		end



		### Overloading hierachy getters of Node.
		### @{
		def in_scene?
			!@application.nil?
		end

		def scene
			self
		end

		def scene? : Scene|Nil
			self
		end


		def viewport
			@viewport
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



		def enter_scene
			if @application.nil?
				return
			end

			@viewport.view.size = @application.not_nil!.window.size
			@viewport.view.center = @application.not_nil!.window.view.center

			super
		end


		### Allows to directly draw the scene to a render target.
		###
		def draw( target : SF::RenderTarget, states : SF::RenderStates )
			target, states = pre_render( target, states )
			render( target, states )
			post_render( target, states )
		end

	end # class Scene

end # module Shadow

