module Shack
  class Middleware
    def initialize(app, sha)
      @app = app
      @sha = sha unless (sha || "").empty?
    end

    def call(env)
      status, headers, body = @app.call(env)
      return [status, headers, body] unless @sha

      headers["X-SHACK-SHA"] = @sha

      [status, headers, body]
    end
  end
end
