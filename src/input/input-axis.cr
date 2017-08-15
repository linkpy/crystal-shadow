
require "crsfml"


module Shadow

	### Base class for all input axis.
	###
	abstract class InputAxis


		### Speed at which the value goes to the raw value when it's outside of
		### the dead zone.
		property sensitivity : Float32
		### Speed at which the value goes to 0 when the raw value is in the
		### dead zone.
		property gravity : Float32
		### Range from `-dead_zone` to `dead_zone` where the raw input is
		### mapped to 0.
		property dead_zone : Float32

		### Inverts the sign of the raw value.
		property invert : Bool
		### Resets the `value` to zero when the rawv
		property snap : Bool



		### Initializes a new instance.
		###
		def initialize
			@sensitivity = 1f32
			@gravity = 1f32
			@dead_zone = 0.005_f32

			@invert = false
			@snap = false

			@value = 0f32
		end



		### Updates the axis's value.
		###
		def update( dt : SF::Time )
			if raw_value.abs > 0f32
				if @snap && raw_value.sign != @value.sign
					@value = 0f32
				end

				@value = @value + (raw_value - @value)*dt.as_seconds*@sensitivity
			else
				@value = @value + -@value*dt.as_seconds*@gravity
			end
		end



		### Gets the axis value.
		###
		def value : Float32
			@value
		end



		### Gets the initially processed raw value (handling the dead zone and
		### the invert).
		###
		def raw_value : Float32
			rv = _raw_value

			if rv.abs < @dead_zone
				0f32
			else
				@invert ? -rv : rv
			end
		end

		### Gets the axis raw value.
		###
		protected abstract def _raw_value : Float32


	end



	### Base class for digital input axis.
	###
	abstract class InputBinaryAxis < InputAxis


		### Initializes a new instance.
		###
		def initialize
			super
		end



		### Gets the unproccessed raw value.
		###
		protected def _raw_value : Float32
			(is_positive? ? 1f32 : 0f32) - (is_negative? ? 1f32 : 0f32)
		end



		### Is the axis in its positive state ?
		###
		protected abstract def is_positive? : Bool

		### Is the axis in its negative state ?
		###
		protected abstract def is_negative? : Bool

	end


	### An input axis using keys for computing the raw value.
	###
	class InputKeyAxis < InputBinaryAxis

		### Key mapping the raw axis value to +1.
		property positive : SF::Keyboard::Key|Nil
		### Key mapping the raw axis value to -1.
		property negative : SF::Keyboard::Key|Nil

		### Alternative key mapping the raw axis value to +1.
		property positive_alt : SF::Keyboard::Key|Nil
		### Alternative key mapping the raw axis value to -1.
		property negative_alt : SF::Keyboard::Key|Nil



		### Initializes a new instance.
		###
		def initialize
			super
		end



		### Is the axis in its positive state ?
		###
		protected def is_positive? : Bool
			if !@positive.nil?
				return true if SF::Keyboard.key_pressed? @positive.not_nil!
			end

			if !@positive_alt.nil?
				return SF::Keyboard.key_pressed? @positive_alt.not_nil!
			end

			false
		end

		### Is the axis in its negative state ?
		###
		protected def is_negative? : Bool
			if !@negative.nil?
				return true if SF::Keyboard.key_pressed? @negative.not_nil!
			end

			if !@negative_alt.nil?
				return SF::Keyboard.key_pressed? @negative.not_nil!
			end

			false
		end

	end



	### Input axis using mouse buttons.
	###
	class InputMouseButtonAxis < InputBinaryAxis

		### Button mapping the raw axis to +1.
		property positive : SF::Mouse::Button|Nil
		### Button mapping the raw axis to -1.
		property negative : SF::Mouse::Button|Nil

		### Alternate button mapping the raw axis to +1.
		property positive_alt : SF::Mouse::Button|Nil
		### Alternate button mapping the raw axis to -1.
		property negative_alt : SF::Mouse::Button|Nil



		### Initializes a new instance.
		###
		def initialize
			super
		end



		### Is the axis in its positive state ?
		###
		protected def is_positive? : Bool
			if !@positive.nil?
				return true if SF::Mouse.button_pressed? @positive.not_nil!
			end

			if !@positive_alt.nil?
				return SF::Mouse.button_pressed? @positive_alt.not_nil!
			end

			false
		end

		### Is the axis in its negative state ?
		###
		protected def is_negative? : Bool
			if !@negative.nil?
				return true if SF::Mouse.button_pressed? @negative.not_nil!
			end

			if !@negative_alt.nil?
				return SF::Mouse.button_pressed? @negative.not_nil!
			end

			false
		end

	end


end
