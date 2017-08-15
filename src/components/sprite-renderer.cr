
require "crsfml"
require "../scene/component.cr"
require "../core/resource-link.cr"


module Shadow::Components

	### A simple sprite component.
	###
	class SpriteRenderer < Shadow::Component


		@modulate : SF::Color



		property texture : Shadow::ResourceLink(SF::Texture)



		### Initializes a new instance.
		###
		def initialize( @texture )
			super()

			@rectangle = SF::IntRect.new
			@modulate = SF::Color::White

			texsize = @texture.resource.size
			@rectangle.width = texsize.x
			@rectangle.height = texsize.y

			@_varray = SF::VertexArray.new SF::TrianglesFan, 4
			_update_vertices
		end



		### Updates the vertex array.
		###
		private def _update_vertices
			texsize = @texture.resource.size

			tl = SF.vector2i @rectangle.left, @rectangle.top
			br = SF.vector2i tl.x + @rectangle.width, tl.y + @rectangle.height

			tex_tl = SF.vector2f	tl.x.to_f32, tl.y.to_f32
			tex_tr = SF.vector2f	br.x.to_f32, tex_tl.y
			tex_br = SF.vector2f	tex_tr.x, br.y.to_f32
			tex_bl = SF.vector2f	tex_tl.x, tex_br.y

			v = SF::Vertex.new

			v.position = SF.vector2f 0f32, 0f32
			v.tex_coords = tex_tl
			v.color = @modulate
			@_varray[ 0 ] = v

			v.position = SF.vector2f @rectangle.width.to_f32, 0f32
			v.tex_coords = tex_tr
			@_varray[ 1 ] = v

			v.position = SF.vector2f @rectangle.width.to_f32, @rectangle.height.to_f32
			v.tex_coords = tex_br
			@_varray[ 2 ] = v

			v.position = SF.vector2f 0f32, @rectangle.height.to_f32
			v.tex_coords = tex_bl
			@_varray[ 3 ] = v
		end



		### Gets the texture position.
		###
		def tex_position
			SF.vector2f @rectangle.left.to_f32, @rectangle.top.to_f32
		end

		### Sets the texture position.
		###
		def tex_position=( v )
			@rectangle.left = v.x.to_i
			@rectangle.top = v.y.to_i
			_update_vertices
			v
		end

		### Gets the texture size.
		###
		def tex_size
			SF.vector2f @rectangle.width.to_f32, @rectangle.height.to_f32
		end

		### Sets the texture size.
		###
		def tex_size=( v )
			@rectangle.left = v.x.to_i
			@rectangle.top = v.y.to_i
			_update_vertices
			v
		end



		### Gets the sprite color.
		###
		def modulate
			@modulate
		end

		### Sets the sprite color.
		###
		def modulate=( col )
			@modulate = col
			_update_vertices
			v
		end




		def render( target, states )
			states.texture = @texture.resource
			target.draw( @_varray, states )
		end

	end

end

