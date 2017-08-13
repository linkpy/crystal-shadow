
require "crsfml"
require "./scene/scene"


module Shadow

	### Base class for an application.
	###
	abstract class Application


		### Gets the window.
		###
		getter window : SF::RenderWindow
		### Gets the scenes.
		###
		getter scenes : Array(Scene)



		### Initializes a new instance.
		###
		def initialize
			@window = SF::RenderWindow.new
			@scenes = Array(Scene).new
			@clock = SF::Clock.new
		end



		### Runs the application (mainloop).
		###
		def run

			@window.create video_mode, title, style, context
			self << initial_scene
			@clock.restart

			while @window.open?

				if @scenes.size == 0
					puts "Stopping app : No more scene."
					@window.close
					break
				end

				s = @scenes[ @scenes.size - 1 ]

				while event = @window.poll_event
					if event.is_a? SF::Event::Closed
						@window.close
					end

					if !s.event event
						s.unhandled_event event
					end
				end

				dt = @clock.elapsed_time
				@clock.restart

				s.pre_update dt
				s.update dt
				s.post_update dt

				@window.clear SF::Color::Black
				@window.draw s
				@window.display

				s.late_update dt

			end

		end



		### Initial video mode of the application.
		###
		def video_mode : SF::VideoMode
			SF::VideoMode.new 800, 600
		end

		### Initial title of the application's window.
		###
		def title : String
			"Crystal-Shadow"
		end

		### Initial style of the application's window.
		###
		def style : SF::Style
			SF::Style::Default
		end

		### Initial context settings of the application's window.
		###
		def context : SF::ContextSettings
			SF::ContextSettings.new
		end



		### Initial scene of the application.
		###
		abstract def initial_scene : Scene



		### Pushes a scene on the scene stack.
		###
		def <<( s : Scene )
			@scenes << s
			s.application = self
		end



		### Pushes a scene on the scene stack.
		###
		def push( s : Scene )
			@scenes << s
			s.application = self
		end

		### Pops a scene from the scene stack.
		###
		def pop
			s = @scenes.pop
			s.application = nil
		end


	end # class Application

end # module Shadow

