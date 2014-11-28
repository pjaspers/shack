require "bundler/gem_tasks"

task :test do
  $LOAD_PATH.unshift('lib', 'test')
  Dir.glob('./test/**/*_test.rb') { |f| require f }
end

task :default => :test

task :console do
  require 'pry'
  require './lib/shack'
  ARGV.clear
  Pry.start Frasier
end
