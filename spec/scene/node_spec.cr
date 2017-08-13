
require "spec"
require "../../src/scene/node.cr"


class TestOneComponent < Shadow::Component
end

class TestTwoComponent < Shadow::Component
end



describe "Shadow::Node" do

	describe "/ Components" do

		it "adds/removes component" do
			node = Shadow::Node.new

			node << TestOneComponent.new
			node.components.size.should eq 1

			node << TestTwoComponent.new
			node.components.size.should eq 2

			node.has_component?( TestOneComponent ).should be_true
			node.component?( TestTwoComponent ).nil?.should be_false

			node.delete :TestOneComponent
			node.components.size.should eq 1

			node.delete TestTwoComponent
			node.components.size.should eq 0
		end

	end

end

