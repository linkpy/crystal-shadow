
require "spec"
require "../../src/scene/component-collection.cr"

class TestComponent < Shadow::Component

	def initialize
		super
	end

end


describe "Shadow::ComponentCollection" do

	describe "/ Dynamic Extensions" do

		it "adds component" do
			col = Shadow::ComponentCollection.new
			comp = TestComponent.new

			col << comp
			col.size.should eq 1

			col[ :TestComponent ].should eq comp
			col[ TestComponent ].should eq comp

			col << comp
			col.size.should eq 1
		end

		it "deletes component" do
			col = Shadow::ComponentCollection.new
			comp = TestComponent.new

			col << comp
			col.delete :TestComponent
			col.size.should eq 0

			col << comp
			col.delete TestComponent
			col.size.should eq 0
		end

	end

end
