module Shack
  class Railtie < Rails::Railtie
    initializer "shack.configure_rails_initialization" do |app|
      ShackRails.new(app).inject!
    end
  end

  class ShackRails
    def initialize(app)
      @app = app
    end

    def inject!
      if Rails.env.production?
        # Don't show the stamp in production, but do add it to the headers
        Shack::Middleware.configure do |shack|
          shack.hide_stamp = true
        end
      end

      if fetch_sha_from_file?
        Shack::Middleware.configure do |shack|
          shack.sha = File.open(revision_file).read.strip
        end
      end
      @app.middleware.use(Shack::Middleware)
    end

    def fetch_sha_from_file?
      Shack.sha.blank? && File.exist?(revision_file)
    end

    def revision_file
      File.join(Rails.root, "REVISION")
    end
  end
end
