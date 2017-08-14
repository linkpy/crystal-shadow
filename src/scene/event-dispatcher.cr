
require "crsfml"


module Shadow

	module EventDispatcher

		{% begin %}

		{%
			events = [
				"Resized", "LostFocus", "GainedFocus",
				"TextEntered", "KeyPressed", "KeyReleased",
				"MouseWheelMoved", "MouseWheelScrolled",
				"MouseButtonPressed", "MouseButtonReleased",
				"MouseMoved", "MouseEntered", "MouseLeft",
				"JoystickButtonPressed", "JoystickButtonReleased",
				"JoystickMoved", "JoystickConnected",
				"JoystickDisconnected", "TouchBegan", "TouchMoved",
				"TouchEnded", "SensorChanged"
			]
		%}

		### Handles the given event.
		### It will dispatch the event to all subfunctions.
		###
		def dispatch_event( ev : SF::Event ) : Bool
			case ev
			{% for event in events %}
			when SF::Event::{{event.id}}
				on_{{event.underscore.id}}( ev )
			{% end %}
			else
				false
			end
		end


		{% for event in events %}

		### Handles an event of type `SF::Event::{{event.id}}`.
		###
		def on_{{event.underscore.id}}( ev : SF::Event::{{event.id}} ) : Bool
			false
		end

		{% end %}

		{% end %}

	end

end
