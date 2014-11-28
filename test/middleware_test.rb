require "helper.rb"
require "rack/mock"

describe Shack::Middleware do
  before do
    @app = ->(env) { [200, env, "app"] }
  end

  describe "without a sha" do
    before do
      @middleware = Shack::Middleware.new(@app, "")
    end

    it "doesn't break the original app" do
      status, _, _ = @middleware.call(fake_env("http://something.com"))
      assert_equal status, 200
    end

    it "doesn't set a header" do
      _, headers, _ = @middleware.call(fake_env("http://something.com"))
      assert_nil headers["X-SHACK-SHA"]
    end
  end

  describe "with a sha" do
    before do
      @sha = "abc123def4"
      @middleware = Shack::Middleware.new(@app, @sha)
    end

    it "doesn't break the original app" do
      status, _, _ = @middleware.call(fake_env("http://something.com"))
      assert_equal status, 200
    end

    it "sets the header to the sha" do
      _, headers, _ = @middleware.call(fake_env("http://something.com"))
      assert_equal @sha, headers["X-SHACK-SHA"]
    end
  end

  def fake_env(url, options = {})
    Rack::MockRequest.env_for(url, options)
  end
end
