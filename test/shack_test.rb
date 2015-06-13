require "helper"

describe Shack do
  it "returns nil if it can't find a sha" do
    if Shack.class_variable_defined? "@@sha"
      Shack.remove_class_variable "@@sha"
    end
    assert_nil Shack.sha
  end
end
