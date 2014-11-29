require "helper.rb"
require "rack/mock"

describe Shack::Stamp do
  describe ".stampable?" do
    {"text/html" => true, "application/json" => false, "text/plain" => false}.each do |content_type, stampable|
      in_words = stampable ? "stampable" : "unstampable"
      it "#{content_type} is #{in_words}" do
        assert_equal stampable, Shack::Stamp.stampable?("Content-Type" => content_type)
      end
    end
  end

  describe "stamping" do
    it "should do nothing if no </body> found" do
      s = Shack::Stamp.new("something", "Jack Vincennes")
      assert_equal "something", s.result
    end

    it "should add content if </body> found" do
      s = Shack::Stamp.new("<html><body></body></html>", "Jack Vincennes")
      assert_match(/Jack Vincennes/, s.result)
    end
  end
end
