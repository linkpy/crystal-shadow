
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



		@global_matrix : SF::Transform|Nil
		@global_inv_matrix : SF::Transform|Nil



		### Initialies a new instance.
		###
		def initialize
			super
			@transform = SF::Transformable.new

			@global_matrix = nil
			@global_inv_matrix = nil
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



		### Invalidates the transform and its children.
		###
		@[AlwaysInline]
		protected def invalidate
			if !@global_matrix.nil?
				node.all_in_children( Transform, shallow: true ).each do |comp|
					comp.invalidate
				end
			end

			@global_matrix = nil
			@global_inv_matrix = nil
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
			invalidate
			p
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
			invalidate
			r
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
			invalidate
			s
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
			invalidate
			o
		end



		### Sets the position.
		###
		def set_position( x, y )
			@transform.set_position x, y
			invalidate
			self
		end

		### Sets the scale.
		###
		def set_scale( x, y )
			@transform.set_scale x, y
			invalidate
			self
		end

		### Sets the origin.
		###
		def set_origin( x, y )
			@transform.set_origin x, y
			invalidate
			self
		end



		### Moves the transform.
		###
		def move( x, y )
			@transform.move x, y
			invalidate
			self
		end

		### Moves the transform.
		###
		def move( v )
			@transform.move v
			invalidate
			self
		end

		### Rotates the transform.
		###
		def rotate( r )
			@transform.rotate r
			invalidate
			self
		end

		### Scales the transform.
		###
		def scale( x, y )
			@transform.scale x, y
			invalidate
			self
		end

		### Scales the transform.
		###
		def scale( v )
			@transform.scale v
			invalidate
			self
		end



		### Gets the transform matrix.
		###
		def get_transform
			@transform.transform
		end

		### Gets the inverse transform matrix.
		###
		def get_inv_transform
			@transform.inverse_transform
		end

		def get_global_transform
			if @global_matrix.nil?
				pcomp = node.first_in_ancestry Transform

				if !pcomp.nil?
					@global_matrix = pcomp.get_global_transform *
						@tranform.transform
				else
					@global_matrix = @transform.transform
				end
			end

			@global_matrix.not_nil!
		end

		def get_global_inv_transform
			if @global_inv_matrix.nil?
				@global_inv_matrix = get_global_transform.inverse
			end

			@global_inv_matrix.not_nil!
		end



		### Transforms a local vector to world space.
		###
		def local_to_world( x, y )
			@transform.transform.transform_point x, y
		end

		### Transforms a local vector to world space.
		###
		def local_to_world( v )
			@transform.transform.transform_point v
		end

		### Transforms a world vector to local space.
		###
		def world_to_local( x, y )
			@transform.inverse_transform.transform_point x, y
		end

		### Transforms a world vector to local space.
		###
		def world_to_local( v )
			@transform.inverse_transform.transform_point v
		end




		def pre_render( target : SF::RenderTarget, states : SF::RenderStates )
			states.transform *= @transform.transform
			{ target, states }
		end

	end

end
