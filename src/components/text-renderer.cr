
require "crsfml"

require "../scene/component.cr"
require "../core/resource-link.cr"


module Shadow::Components

	### A simple text renderer.
	###
	class TextRenderer < Shadow::Component

		@text : SF::Text


		### Gets the font used by the text.
		getter font : Shadow::ResourceLink(SF::Font)



		### Initializes a new instance.
		###
		def initialize( @font )
			super()

			@text = SF::Text.new "", font.resource, 12
		end



		### Displayed text.
		###
		def string
			@text.string
		end

		### Sets the displayed text.
		###
		def string=( v )
			@text.string = v
		end



		### Sets the used font.
		###
		def font=( v : Shadow::ResourceLink(SF::Font) )
			@font = v
			@text.font = v.resource
		end



		### Gets the text style.
		###
		def style
			@text.style
		end

		### Sets the text style.
		###
		def style=( v )
			@text.style = v
		end



		### Gets the fill color.
		###
		def fill_color
			@text.fill_color
		end

		### Sets the fill color.
		###
		def fill_color=( v )
			@text.fill_color = v
		end



		### Gets the outline color.
		###
		def outline_color
			@text.outline_color
		end

		### Sets the outline color.
		###
		def outline_color=( v )
			@text.outline_color = v
		end



		### Gets the outline thickness.
		###
		def outline_thickness
			@text.outline_thickness
		end

		### Sets the outline thickness.
		###
		def outline_thickness=( v )
			@text.outline_thickness = v
		end



		### Gets the character size.
		###
		def character_size
			@text.character_size
		end

		### Sets the character size.
		###
		def character_size=( v )
			@text.character_size = v
		end




		def render( target : SF::RenderTarget, states : SF::RenderStates )
			target.draw @text
		end

	end

end

