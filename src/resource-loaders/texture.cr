
require "crsfml"
require "../core/resource.cr"

module Shadow::ResourceLoaders


	### Resource loader for `SF::Texture`
	###
	class TextureLoader < Shadow::ResourceLoader(SF::Texture)

		### Loads the texture at the given path.
		###
		def self.load( path : String ) : Shadow::Resource(SF::Texture)
			tex = SF::Texture.new
			unless tex.load_from_file( path )
				raise Exception.new "Failed to load image '#{path}' !"
			end

			Shadow::Resource(SF::Texture).new tex
		end

	end


end
