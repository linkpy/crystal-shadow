
require "crsfml"
require "../scene/component.cr"


module Shadow::Components

	### Components that modify the rendering transformation.
	###
	class Transform < Shadow::Component


		### Creates a new instance from a position.
		###
		def self.from_pos( p )
			new p
		end

		### Creates a new instance from a position.
		###
		def self.from_pos( x, y )
			new.tap &.set_position x, y
		end

		### Creates a new instance from a rotation.
		###
		def self.from_rot( r )
			new.tap &.rotation=(r)
		end

		### Creates a new instance from a scale.
		###
		def self.from_scale( s )
			new.tap &.scale=(s)
		end

		### Creates a new instance from a scale.
		###
		def self.from_scale( x, y )
			new.tap &.set_scale x, y
		end

		### Creates a new instance from an origin.
		def self.from_origin( o )
			new.tap &.origin=(o)
		end

		### Creates a new instance from an origin.
		###
		def self.from_origin( x, y )
			new.tap &.set_origin x, y
		end



		### Access to the underlying transform.
		getter transform : SF::Transformable



		### Initialies a new instance.
		###
		def initialize
			super
			@transform = SF::Transformable.new
		end

		### Initialies a new instance.
		###
		def initialize( p )
			initialize
			position = p
		end

		### Initialies a new instance.
		###
		def initialize( p, r )
			initialize
			position = p
			rotation = r
		end

		### Initialies a new instance.
		###
		def initialize( p, r, s )
			initialize
			position = p
			rotation = r
			scale = s
		end

		### Initialies a new instance.
		###
		def initialize( p, r, s, o )
			initialize
			position = p
			rotation = r
			scale = s
			origin = o
		end



		### Gets the position.
		###
		def position
			@transform.position
		end

		### Sets the position.
		###
		def position=( p )
			@transform.position = p
		end

		### Gets the rotation.
		###
		def rotation
			@transform.rotation
		end

		### Sets the rotation.
		###
		def rotation=( r )
			@tranform.rotation = r
		end

		### Gets the scale.
		###
		def scale
			@transform.scale
		end

		### Sets the scale.
		###
		def scale=( s )
			@transform.scale = s
		end

		### Gets the origin.
		###
		def origin
			@transform.origin
		end

		### Sets the origin.
		###
		def origin=( o )
			@transform.origin = o
		end



		### Sets the position.
		###
		def set_position( x, y )
			@transform.set_position x, y
		end

		### Sets the scale.
		###
		def set_scale( x, y )
			@transform.set_scale x, y
		end

		### Sets the origin.
		###
		def set_origin( x, y )
			@transform.set_origin x, y
		end



		### Moves the transform.
		###
		def move( x, y )
			@transform.move x, y
		end

		### Moves the transform.
		###
		def move( v )
			@transform.move v
		end

		### Rotates the transform.
		###
		def rotate( r )
			@transform.rotate r
		end

		### Scales the transform.
		###
		def scale( x, y )
			@transform.scale x, y
		end

		### Scales the transform.
		###
		def scale( v )
			@transform.scale v
		end




		def pre_render( target : SF::RenderTarget, states : SF::RenderStates )
			states.transform *= @transform.transform
			{ target, states }
		end

	end

end
