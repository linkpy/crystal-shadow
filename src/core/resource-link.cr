
require "./resource.cr"


module Shadow

	### A weak reference to a resource.
	###
	class ResourceLink(T)

		### Initializes a new instance.
		###
		def initialize( res : WeakRef(Resource(T)) )

			unless res.value
				raise ArgumentError.new "The reference needs to be valid."
			end

			@resource = res
			res.value.not_nil!.ref

		end

		### Finalizes the instance.
		###
		def finalize
			if @resource.value
				@resource.value.not_nil!.unref
			end
		end



		### Checks if the link is valid.
		###
		def valid?
			return @resource.value.not_nil!.has_data? unless @resource.value.nil?
			false
		end



		### Gets the linked resource.
		###
		def resource : T
			@resource.value.not_nil!.data
		end

		### Gets the linked resource.
		###
		def resource? : T?
			return @resource.value.not_nil!.data? unless @resource.value.nil?
			nil
		end



		### Is the linked resource set as kept loaded ?
		###
		def keep_loaded?
			@resource.value.not_nil!.keep_loaded?
		end

		### Sets the linked resource to be kept loaded.
		###
		def keep_loaded=( v )
			@resource.value.not_nil!.keep_loaded = v
		end



		### Duplicates the link.
		###
		def dup
			unless @resource.value.nil?
				raise Exception.new "Can't duplicated an invalide link."
			end

			ResourceLink.new @resource
		end

	end

end

