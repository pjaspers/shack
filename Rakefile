require "bundler/gem_tasks"

task :test do
  $LOAD_PATH.unshift('lib', 'test')
  Dir.glob('./test/**/*_test.rb') { |f| require f }
end

task :default => :test

desc "Drops you in a repl with Shack already loaded"
task :console do
  require 'pry'
  require './lib/shack'
  ARGV.clear
  Pry.start Shack
end

desc "Starts a small webapp to see shack in action"
task :demo do
  require "rack"
  require "./lib/shack"
  app = Rack::Builder.new do
    Shack::Middleware.configure do |shack|
      shack.sha = "80adf8f24baee8d0feb43cdc1ce744c69a54ac99"
      shack.content = "<a href='https://github.com/pjaspers/shack/commit/{{sha}}'>{{short_sha}}</a>"
    end
    use Shack::Middleware
    run -> (env) {
      [200, {"Content-Type" => "text/html"}, ["<html><body>KAAAHN</body></html>"]]
    }
  end

  Rack::Server.start app: app
end

task :checksum do
  require 'digest/sha2'
  abort_with_error "Set 'GEM' with name-0.x.x to calculate checksum" unless ENV["GEM"]
  name = ENV["GEM"]
  built_gem_path = "pkg/#{name}.gem"
  checksum = Digest::SHA512.new.hexdigest(File.read(built_gem_path))
  checksum_path = "checksum/#{name}.sha512"
  File.open(checksum_path, 'w' ) {|f| f.write(checksum) }
  puts "Wrote checksum to #{checksum_path}"
end
