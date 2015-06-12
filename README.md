# Shack

[![Build Status](https://travis-ci.org/pjaspers/shack.svg?branch=master)](https://travis-ci.org/pjaspers/shack)

A `Rack` middleware that will add a unique identifier (`sha`) to the application. It will set a custom header (`X-Shack-Sha`) containing the sha and will automagically insert a small banner in the HTML.

Visit a live demo at https://canadiaweather.herokuapp.com or:

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
  use Shack::Middleware, ENV["SHA"]
  run -> (env) { [200, {"Content-Type" => "text/html", ["<html><body>KAAAHN</body></html>"]]
end

Rack::Server.start app: app
```

If your rack app happens to be a Rails app:

Add `shack` to your Gemfile, and specify how to get the hash in an initializer (`config/initializers/shack.rb`)

```ruby
Shack::Middleware.configure do |shack|
    shack.sha = File.open("BUILD_NUMBER").read.strip
end
```

And since it's Rails, it can also be done automagically if a file called `REVISION` is found in the root of your project. No initializer required. Note: by default it won't show the banner in production environments, because that just feels wrong.

## Configuration

You can either set the sha directly:

```ruby
Shack::Middleware.configure do |shack|
    shack.sha = File.open("REVISION").read.strip
    shack.hide_stamp = true # this will hide the banner
end
```

Or you can set the string to show in the HTML banner (with `{{sha}}` being a special variable which will be replaced with the sha):

```ruby
Shack::Middleware.configure do |shack|
  shack.sha = File.open("REVISION").read.strip
  shack.content = "#{Rails.env} - <a href="https://github.com/shack/commit/{{sha}}>{{sha}}</a>"
end
```

There is also a `{{short_sha}}` substition available, which returns the first 8 chars of the set `sha`.

## Styling

If you define your own CSS for `#shack-stamp` and `#shack-stamp__content`, you can override the default styling. (It uses classes so your specificity should be higher)

## How do I set the sha?

Either write it to a `REVISION` file on deploy (Capistrano used to this by default, now you can [add a task](https://github.com/capistrano/capistrano/pull/757), in `mina` I'm waiting on this [pull request](https://github.com/mina-deploy/mina/pull/260)), or set an `ENV` variable containing the sha.

So instead of using regular mina add this to your Gemfile:

```
gem "mina", git: "https://github.com/pjaspers/mina.git", branch: "pj-write-sha-to-revision-file"
```

Now you can set the sha in the configure block.

## OK that's fine, but I'm on Heroku

In [canadia](https://github.com/pjaspers/canadia) I made an after deploy hook that added an `ENV` variable which set the sha. The easiest way I could do this is with something like this:

```
curl -n -H "Authorization: Bearer $HEROKU_API_KEY" -X PATCH https://api.heroku.com/apps/canadiaweather/config-vars -H "Accept: application/vnd.heroku+json; version=3" -H "Content-Type: application/json" -d '{"SHA":"'"$TRAVIS_COMMIT"'"}'
```

(I used Travis to do the deploying, look [here](https://github.com/pjaspers/canadia/blob/8201454ed538ade36e133645bf1fcd1ee10e05a6/.travis.yml) for all the glorious details)

## Signed gem

`shack` is cryptographically signed. To be sure the gem you install hasn’t been tampered with:

1. Download certificate https://raw.github.com/pjaspers/shack/certs/pjaspers.pem
2. Add `gem cert –add pjaspers.pem`
3. gem install shack -P HighSecurity

## I don't use Rubies

For the PHP-inclined, [here](https://github.com/turanct/shack) is a PHP version by [@tinydroptest2](https://twitter.com/tinydroptest2).

## Contributing

0. Fork it ( https://github.com/pjaspers/shack/fork )
1. Create a new Pull Request
2. Technology.
