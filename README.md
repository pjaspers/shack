# Shack

A `Rack` middleware that will add a `sha` (if one is found in a `REVISION` file) to the application. Either as a custom header: `X-SHACK-SHA` or with an automagically inserted banner in the HTML.

## Installation

For a rack app:

```
require "shack"

app = Rack::Builder.new do
  use Shack::Middleware, "<your_sha_here>"
  run -> (env) { [200, {"Content-Type" => "text/html", ["<html><body>KAAAHN</body></html>"]]
end

Rack::Server.start app: app
```

If your rack app happens to be a Rails app:

Add `shack` to your Gemfile, and specify how to get the hash in an initializer (`config/initializers/shack.rb`)

```
Shack::Middleware.configure do |shack|
    shack.sha = "<your_sha_here"
end
```

And since it's Rails, it can also be done automagically if a file called `REVISION` is found in the root of your project. No initializer required.

## Configuration

You can either set the sha directly:

```
Shack::Middleware.configure do |shack|
    shack.sha = File.open("REVISION").read.strip
end
```

Or you can set the string to show in the HTML banner (with `{{sha}}` being a special variable which will be replaced with the sha):

```
Shack::Middleware.configure do |shack|
  shack.sha = File.open("REVISION").read.strip
  shack.content = "#{Rails.env} - <a href="https://github.com/shack/commit/{{sha}}>{{sha}}</a>"
end
```

## Contributing

0. Fork it ( https://github.com/pjaspers/shack/fork )
1. Create a new Pull Request
2. Technology.
