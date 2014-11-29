module Shack
  class Railtie < Rails::Railtie
    initializer "shack.configure_rails_initialization" do |app|
      app.middleware.use(Shack::Middleware)
    end
  end
end
