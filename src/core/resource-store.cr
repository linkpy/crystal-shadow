
require "./resource.cr"


module Shadow


	### A resource store.
	###
	class ResourceStore
		include Enumerable({Symbol, AbstractResource})
		include Iterable({Symbol, AbstractResource})



		### Initializes a new instance.
		###
		def initialize
			@store = Hash(Symbol, AbstractResource).new
			@contentdir = "./"
		end



		### Iterates over the resources.
		###
		def each
			@store.each
		end

		### Enumerates the resources.
		###
		def each( &block )
			@store.each block
		end



		### Removes all resources no longer referenced.
		###
		def clean
			@store.delete_if do |k, res|
				!res.keep_loaded? && res.ref_count <= 0
			end
			self
		end


	end

end

