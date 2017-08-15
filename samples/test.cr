
require "crsfml"

require "../src/application"
require "../src/components"
require "../src/resource-loaders"
require "../src/core/resource-store.cr"
require "../src/input/input-map.cr"


include Shadow
include SF


class TestApp < Application

	def initialize
		super
		@store = ResourceStore.new

		InputMap[ :hor ] = Shadow::InputKeyAxis.new.tap do |axis|
			axis.positive = SF::Keyboard::D
			axis.negative = SF::Keyboard::Q
			axis.sensitivity = 10f32
			axis.gravity = 10f32
		end

		InputMap[ :ver ] = Shadow::InputKeyAxis.new.tap do |axis|
			axis.positive = SF::Keyboard::S
			axis.negative = SF::Keyboard::Z
			axis.sensitivity = 10f32
			axis.gravity = 10f32
		end
	end

	def initial_scene : Scene
		Scene.new.tap do |s|
			s << Node.new.tap do |n|

				n << Components::Viewport.new.tap do |c|
					c.bottom = 0.5f32
				end

				n << Node.new.tap do |n|
					trans = Components::Transform.from_pos 50, 50

					n << trans
					n << Components::SpriteRenderer.new @store.load( Texture,
								:testTex, "./samples/data/test.png" )

					n << Components::Simple[
						update: ->(node : Components::Simple, dt : SF::Time) {
							trans.move InputMap.value( :hor, :ver ) * 50f32 *
								dt.as_seconds
							nil
						}
					]
				end

			end
		end
	end

	def title : String
		"Test Application"
	end

end

app = TestApp.new
app.run
