module Shack
  class Middleware
    HEADER_NAME = "X-Shack-Sha".freeze

    def initialize(app, sha = "")
      @app = app
      @sha = sha unless (sha || "").empty?
    end

    def call(env)
      status, headers, body = @app.call(env)
      return [status, headers, body] unless @sha
      headers[HEADER_NAME] = @sha

      if result = inject_stamp(env, status, headers, body)
        result
      else
        [status, headers, body]
      end
    end

    def inject_stamp(env,status,headers,body)
      return nil unless Stamp.stampable?(headers)
      response = Rack::Response.new([], status, headers)

      if String === body
        response.write Stamp.new(body, @sha).result
      else
        body.each do |fragment|
          response.write Stamp.new(fragment, @sha).result
        end
      end
      body.close if body.respond_to? :close
      response.finish
    end

  end
end
