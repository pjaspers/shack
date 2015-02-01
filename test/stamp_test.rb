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

    it "should use custom_content if provided" do
      s = Shack::Stamp.new("<html><body></body></html>", "Jack Vincennes", "Rollo Tomassi")
      assert_match(/Rollo Tomassi/, s.result)
    end

    it "should use sha in custom_content if provided" do
      s = Shack::Stamp.new("<html><body></body></html>", "Jack Vincennes", "Rollo Tomassi said {{sha}}")
      assert_match(/Rollo Tomassi said Jack Vincennes/, s.result)
    end

    it "uses short sha in custom_content if wanted" do
      s = Shack::Stamp.new("<html><body></body></html>", "Jack Vincennes", "Rollo Tomassi said {{short_sha}}")
      assert_match(/Rollo Tomassi said Jack Vi/, s.result)
      refute_match(/Jack Vincennes/, s.result)
    end
  end
end
