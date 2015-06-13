require "helper.rb"
require "rack/mock"

describe Shack::Middleware do
  before do
    @app = ->(env) { [200, env, "app"] }
    reset_config
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

    it "doesn't break the original app" do
      status, _, _ = @middleware.call(fake_env("http://something.com"))
      assert_equal status, 200
    end

    it "sets the header to the sha" do
      _, headers, _ = @middleware.call(fake_env("http://something.com"))
      assert_equal @sha, headers[Shack::Middleware::HEADER_NAME]
    end

    it "exposes the sha to the top Shack module" do
      assert_equal @sha, Shack.sha
    end
  end

  describe "injecting html" do
    it "adds a stamp if content-type is text/html" do
      app = ->(_) { [200, { "Content-Type" => "text/html" }, fake_page] }
      middleware = Shack::Middleware.new(app, "Rollo Tomassi")
      _, _, response = middleware.call(fake_env("http://something.com"))
      assert_match(/Rollo Tomassi/, response.body.first)
    end

    it "doesn't inject on xhr requests" do
      app = ->(_) { [200, { "Content-Type" => "text/html" }, fake_page] }
      middleware = Shack::Middleware.new(app, "Rollo Tomassi")
      _, _, response = middleware.call(xhr_env("http://something.com"))
      assert_match(/Rollo Tomassi/, response.body.first)
    end

  end

  describe ".configure" do

    it "can set a sha" do
      Shack::Middleware.configure { |s| s.sha = "O'Sullivan" }
      assert_equal Shack::Middleware.config.sha, "O'Sullivan"
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
      assert_equal Shack::Middleware.config.content, string
    end

    it "can can set the horizontal orientation" do
      response = response_from_configured_app do |c|
        c.horizontal = :left
      end
      assert_match(/left: 0;/, response.body.first)
    end

    it "can can set the vertical orientation" do
      response = response_from_configured_app do |c|
        c.vertical = :top
      end
      assert_match(/top: 0;/, response.body.first)
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

    it "can set vertical to top" do
      Shack::Middleware.configure { |s| s.vertical = :top }
      assert_equal Shack::Middleware.config.vertical, :top
    end

    it "can set horizontal to left" do
      Shack::Middleware.configure { |s| s.horizontal = :left }
      assert_equal Shack::Middleware.config.horizontal, :left
    end
  end

  def fake_page
    "<html><body></body></html>"
  end

  def fake_env(url, options = {})
    Rack::MockRequest.env_for(url, options)
  end

  def xhr_env(url, options = {})
    options = { "HTTP_X_REQUESTED_WITH" => "XMLHttpRequest"}.merge(options || {})
    Rack::MockRequest.env_for(url, options)
  end

  def reset_config
    Shack::Middleware.configuration = nil
  end

  def response_from_configured_app(&block)
    app = ->(_) { [200, { "Content-Type" => "text/html" }, fake_page] }
    Shack::Middleware.configure { |s| block.call(s) }
    middleware = Shack::Middleware.new(app, "sha")
    _, _, response = middleware.call(fake_env("http://something.com"))
    response
  end
end
