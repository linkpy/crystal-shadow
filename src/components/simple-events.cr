
require "./simple.cr"


module Shadow::Components


	### Extensions of the `Simple` component. This one is easier
	### to use for handling events.
	###
	class SimpleEvents < Simple


		### Initalizes a new instance.
		###
		def initialize
			super()
		end



		### Macro for easier creation of the instance.
		###
		macro [](**args) 
			%ret = {{@type}}.new
			{% for name, proc in args %}
				%ret.{{name.id}} = {{proc}}
			{% end %}
			%ret
		end




		### Handles the given event.
		###
		def event( ev : SF::Event ) : Bool
			dispatch_event ev
		end


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

		{% for event in events %}
			{% cbn = ("@" + event.underscore + "_cb").id %}
		
		{{cbn.id}} : Proc( SimpleEvents, SF::Event::{{event.id}}, Bool )|Nil

		### Defines the call back for the `SF::Event::{{event.id}}` event.
		###
		def on_{{event.underscore.id}}=( p : Proc( SimpleEvents,
												  SF::Event::{{event.id}},
												  Bool ) )
			{{cbn}} = p
		end

		### Handles the event of type `SF::Event::{{event.id}}`.
		###
		def on_{{event.underscore.id}}( ev : SF::Event::{{event.id}} ) : Bool
			unless {{cbn}}.nil?
				{{cbn}}.not_nil!.call self, ev
			else
				false
			end
		end

		{% end %}

		{% end %}

	end

end
