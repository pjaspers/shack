# Shack

A `Rack` middleware that will add a unique identifier (`sha`) to the application. It will set a custom header (`X-Shack-Sha`) containing the sha and will automagically insert a small banner in the HTML.

![Shack in action](http://cl.ly/image/2F1w1E0G2C3R/Screen%20Shot%202014-12-01%20at%2000.47.23.png)

```
❯ curl -I kkez.dev
HTTP/1.1 200 OK
Server: nginx/1.6.1
Date: Sun, 30 Nov 2014 23:49:10 GMT
Content-Type: text/html;charset=utf-8
Content-Length: 491
Connection: keep-alive
X-Shack-Sha: 39aee4f
```

This way you can always be certain which version of your app is currently running, especially handy in staging environments.
If you don't supply a `sha` nothing will happen (so for example if you use an `ENV` variable containing the sha and don't set it in production, no one will be any wiser).

## Installation

For a rack app:

```ruby
require "shack"

app = Rack::Builder.new do
  use Shack::Middleware, "<your_sha_here>"
  run -> (env) { [200, {"Content-Type" => "text/html", ["<html><body>KAAAHN</body></html>"]]
end

Rack::Server.start app: app
```

If your rack app happens to be a Rails app:

Add `shack` to your Gemfile, and specify how to get the hash in an initializer (`config/initializers/shack.rb`)

```ruby
Shack::Middleware.configure do |shack|
    shack.sha = "<your_sha_here"
end
```

And since it's Rails, it can also be done automagically if a file called `REVISION` is found in the root of your project. No initializer required. Note: by default it won't show the `sha` in production environments, because that just feels wrong.

## Configuration

You can either set the sha directly:

```ruby
Shack::Middleware.configure do |shack|
    shack.sha = File.open("REVISION").read.strip
end
```

Or you can set the string to show in the HTML banner (with `{{sha}}` being a special variable which will be replaced with the sha):

```ruby
Shack::Middleware.configure do |shack|
  shack.sha = File.open("REVISION").read.strip
  shack.content = "#{Rails.env} - <a href="https://github.com/shack/commit/{{sha}}>{{sha}}</a>"
end
```

## How do I set the sha?

Either write it to a `REVISION` file on deploy (Capistrano used to this by default, now you can [add a task](https://github.com/capistrano/capistrano/pull/757), in `mina` I'm waiting on this [pull request](https://github.com/mina-deploy/mina/pull/260)), or set an `ENV` variable containing the sha.

Now you can set the sha in the configure block.

## Contributing

0. Fork it ( https://github.com/pjaspers/shack/fork )
1. Create a new Pull Request
2. Technology.
