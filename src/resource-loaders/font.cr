

require "crsfml"
require "../core/resource.cr"

module Shadow::ResourceLoaders


	### Resource loader for `SF::Font`
	###
	class FontLoader < Shadow::ResourceLoader(SF::Font)

		### Loads the at the font given path.
		###
		def self.load( path : String ) : Shadow::Resource(SF::Font)
			tex = SF::Font.new
			unless tex.load_from_file( path )
				raise Exception.new "Failed to load font '#{path}' !"
			end

			Shadow::Resource(SF::Font).new tex
		end

	end


end
