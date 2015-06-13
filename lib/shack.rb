require "shack/version"
require "shack/configuration"
require "shack/middleware"
require "shack/stamp"
require "shack/railtie" if defined?(Rails)

module Shack
  # If the Middleware is called and initialized, this sha will be set
  # This could be used for easy passing to something like `Airbrake`
  def self.sha
    if defined? @@sha
      @@sha
    end
  end

  def self.sha=(sha)
    @@sha = sha
  end
end
