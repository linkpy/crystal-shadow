
require "crsfml"
require "../scene/component.cr"



module Shadow::Components


	### A simple components that calls a set of `Proc` for updating and handling
	### the events.
	###
	class Simple < Shadow::Component


		### Shortcut macro :
		###		node << Components::Simple[
		###			update: ->(node : Components::Simple, dt : SF::Time) {
		###				puts dt.as_seconds
		###				nil
		###			}
		###		]
		###
		macro []( **args )
			%ret = {{@type}}.new
			{% for name, proc in args %}
				%ret.{{name.id}} = {{proc}}
			{% end %}
			%ret
		end



		@pre_upd : Proc( Simple, SF::Time, Nil )|Nil
		@upd : Proc( Simple, SF::Time, Nil )|Nil
		@post_upd : Proc( Simple, SF::Time, Nil )|Nil
		@late_upd : Proc( Simple, SF::Time, Nil )|Nil

		@evt : Proc( Simple, SF::Event, Bool )|Nil
		@unhandled_evt : Proc( Simple, SF::Event, Nil )|Nil



		def initialize
			super()
		end




		def pre_update=( p : Proc(Simple, SF::Time, Nil) )
			@pre_upd = p
		end

		def update=( p : Proc(Simple, SF::Time, Nil) )
			@upd = p
		end

		def post_update=( p : Proc(Simple, SF::Time, Nil) )
			@post_upd = p
		end

		def late_update=( p : Proc(Simple, SF::Time, Nil) )
			@late_upd = p
		end



		def event=( p : Proc(Simple, SF::Event, Bool) )
			@evt = p
		end

		def unhandled_evt( p : Proc(Simple, SF::Event, Nil) )
			@unhandled_evt = p
		end



		def pre_update( dt : SF::Time )
			unless @pre_upd.nil?
				@pre_upd.not_nil!.call self, dt
			end
		end

		def update( dt : SF::Time )
			unless @upd.nil?
				@upd.not_nil!.call self, dt
			end
		end

		def post_update( dt : SF::Time )
			unless @post_upd.nil?
				@post_upd.not_nil!.call self, dt
			end
		end

		def late_update( dt : SF::Time )
			unless @late_upd.nil?
				@late_upd.not_nil!.call self, dt
			end
		end




		def event( ev : SF::Event ) : Bool
			unless @evt.nil?
				@evt.not_nil!.call self, ev
			else
				false
			end
		end

		def unhandled_event( ev : SF::Event )
			unless @unhandled_evt.nil?
				@unhandled_evt.not_nil!.call self, ev
			end
		end


	end


end

