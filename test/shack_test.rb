require "helper"

describe Shack do
  it "returns nil if it can't find a sha" do
    assert_nil Shack.sha
  end
end
