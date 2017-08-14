
require "../weakref"


module Shadow

	class ResourceLink(T)
	end


	### Base class for all resources.
	### Should not be inherited, use `Resource(T)` instead.
	###
	abstract class AbstractResource

		### Initializes a new instance.
		###
		def initialize
			@count = 0
			@keep_loaded = false
		end



		### Gets the number of references.
		###
		def ref_count
			@count
		end

		### Keep the resource loaded even if it's no more referenced ?
		###
		def keep_loaded?
			@keep_loaded
		end

		### Defines if the resource should be kept loaded even if it's doesn't
		### have any reference.
		###
		def keep_loaded=( v )
			@keep_loaded = v
		end



		### Increases the reference counter.
		###
		def ref
			@count += 1
		end

		### Decrease the reference counter.
		###
		def unref
			@count -= 1
		end

	end # class AbstractResource




	### A simple resource.
	###
	class Resource(T) < AbstractResource


		@data : T



		### Initializes a new instance.
		###
		def initialize( @data : T )
			super()
		end



		### Gets the resource's data.
		###
		def data : T
			@data.not_nil!
		end

	end



	### Base class for all resource loader.
	###
	### The class *must* have a class methods `self.load`, taking
	### a `String` and returning a `Resource(T)`.
	###
	abstract class ResourceLoader(T)

		macro inherited

			{% ltype = @type.superclass.type_vars[0] %}

			class ::Shadow::ResourceStore

				### Loads a resource of the type '{{ltype.name}}'.
				###
				def load( k : {{ltype}}.class, name : Symbol,
						path : String ) : ResourceLink({{ltype}})

					if @store[ name ]?
						raise ArgumentError.new "A resource '#{name}' already " +
							"exists."
					end

					res = {{@type}}.load path
					@store[ name ] = res
					ResourceLink({{ltype}}).new WeakRef.new res
				end


				### Gets an already loaded resource of the type '{{ltype.name}}'.
				###
				def get( k : {{ltype}}.class, name : Symbol ) : ResourceLink({{ltype}})

					unless @store[ name ]?
						raise ArgumentError.new "No resource '#{name}' loaded."
					end

					res = @store[ name ]
					unless res.is_a? Resource({{ltype}})
						raise ArgumentError.new "The resource '#{name}' isn't "+
							"a '{{ltype.name}}'."
					end

					ResourceLink({{ltype}}).new WeakRef.new res.as Resource({{ltype}})
				end

			end # class ::Shadow::ResourceStore

		end # macro inherited

	end # class ResourceLoader(T)

end # module Shadow

require "./resource-link.cr"
