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
      assert_nil headers[Shack::Middleware::HEADER_NAME]
    end
  end

  describe "with a sha" do
    before do
      @sha = "abc123def4"
      @middleware = Shack::Middleware.new(@app, @sha)
    end

    after do
      Shack::Middleware.configure do |shack|
        shack.sha = nil
        shack.content = nil
      end
    end

    it "doesn't break the original app" do
      status, _, _ = @middleware.call(fake_env("http://something.com"))
      assert_equal status, 200
    end

    it "sets the header to the sha" do
      _, headers, _ = @middleware.call(fake_env("http://something.com"))
      assert_equal @sha, headers[Shack::Middleware::HEADER_NAME]
    end
  end

  describe "injecting html" do
    it "adds a stamp if content-type is text/html" do
      app = ->(_) { [200, { "Content-Type" => "text/html" }, fake_page] }
      middleware = Shack::Middleware.new(app, "Rollo Tomassi")
      _, _, response = middleware.call(fake_env("http://something.com"))
      assert_match(/Rollo Tomassi/, response.body.first)
    end
  end

  describe ".configure" do
    it "can set a sha" do
      Shack::Middleware.configure { |s| s.sha = "O'Sullivan" }
      assert_equal Shack::Middleware.sha, "O'Sullivan"
    end

    it "favors the initialized sha over the configured one" do
      Shack::Middleware.configure { |s| s.sha = "O'Sullivan" }
      app = ->(_) { [200, { "Content-Type" => "text/html" }, fake_page] }
      s = Shack::Middleware.new(app, "The Rocket")
      assert_equal s.sha, "The Rocket"
    end

    it "can set a custom content string" do
      string = "O'Sullivan - http://bbc.co.uk/{{sha}}"
      Shack::Middleware.configure do |s|
        s.content = string
      end
      assert_equal Shack::Middleware.content, string
    end

    it "sets the stamp with the configuration" do
      app = ->(_) { [200, { "Content-Type" => "text/html" }, fake_page] }
      Shack::Middleware.configure do |s|
        s.sha = "abc123"
        s.content = "Ronnie The Rocket - {{sha}}"
      end
      middleware = Shack::Middleware.new(app)
      _, _, response = middleware.call(fake_env("http://something.com"))
      assert_match(/Ronnie The Rocket - abc123/, response.body.first)
    end
  end
  def fake_page
    "<html><body></body></html>"
  end

  def fake_env(url, options = {})
    Rack::MockRequest.env_for(url, options)
  end
end
