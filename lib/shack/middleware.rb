module Shack
  class Middleware
    HEADER_NAME = "X-Shack-Sha".freeze

    def initialize(app, sha = "")
      @app = app
      @sha = sha unless (sha || "").empty?
    end

    def call(env)
      status, headers, body = @app.call(env)
      return [status, headers, body] unless sha
      headers[HEADER_NAME] = sha

      if result = inject_stamp(status, headers, body)
        result
      else
        [status, headers, body]
      end
    end

    def config
      self.class.config
    end

    def inject_stamp(status, headers, body)
      return nil if !!config.hide_stamp?
      return nil unless Stamp.stampable?(headers)
      response = Rack::Response.new([], status, headers)

      if String === body
        response.write stamped(body)
      else
        body.each do |fragment|
          response.write stamped(fragment)
        end
      end
      body.close if body.respond_to? :close
      response.finish
    end

    # Initialiser over config-sha.
    def sha
      @sha || config.sha
    end

    def stamped(body)
      Stamp.new(body, sha, config.content).result
    end

    class << self
      attr_writer :configuration

      def config
        @configuration ||= Configuration.new
      end

      # Allow configuration of the Middleware
      #
      #      Shack::Middleware.configure do |shack|
      #        shack.sha = "thisiasha"
      #        shack.hide_stamp = true
      #      end
      #
      def configure(&block)
        block.call(config)
      end
    end
  end
end
