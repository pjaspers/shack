require "helper.rb"

describe Shack::Configuration do

  it "defaults vertical to bottom" do
    assert_equal :bottom, Shack::Configuration.new.vertical
  end

  it "defaults horizontal to right" do
    assert_equal :right, Shack::Configuration.new.horizontal
  end

  it "has handy hide_stamp?" do
    config = Shack::Configuration.new
    config.hide_stamp = nil
    refute config.hide_stamp?
  end

  it "raises for invalid horizontal settings" do
    config = Shack::Configuration.new
    assert_raises(ArgumentError) { config.horizontal = "Green Mile" }
  end

  it "raises for invalid vertical settings" do
    config = Shack::Configuration.new
    assert_raises(ArgumentError) { config.vertical = "Green Mile" }
  end
end
