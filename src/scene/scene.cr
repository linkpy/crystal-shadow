
require "crsfml"
require "./node.cr"



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

			if @application.nil? && !app.nil?
				@application = app
				self.enter_scene
			elsif !@application.nil? && app.nil?
				self.exit_scene
				@application = nil
			elsif !@application.nil? && @application != app
				self.exit_scene
				@application = app
				self.enter_scene
			end

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

