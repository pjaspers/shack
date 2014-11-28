module Shack
  class Middleware
    HEADER_NAME = "X-Shack-Sha".freeze

    def initialize(app, sha)
      @app = app
      @sha = sha unless (sha || "").empty?
    end

    def call(env)
      status, headers, body = @app.call(env)
      return [status, headers, body] unless @sha

      headers[HEADER_NAME] = @sha

      [status, headers, body]
    end
  end
end
