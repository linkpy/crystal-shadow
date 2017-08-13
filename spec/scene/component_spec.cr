
require "spec"
require "../../src/scene/component.cr"



class TestComponent < Shadow::Component
	def initialize
		super
	end
end

class ChildComponent < TestComponent
	def initialize
		super
	end
end


describe "Shadow::Component" do

	describe "/ Symbols Generation Macro" do

		it "generates a symbol for a subclass" do
			TestComponent.symbol.should eq :TestComponent
			ChildComponent.symbol.should eq :ChildComponent
		end

	end

end

