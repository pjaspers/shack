# -*- coding: utf-8 -*-
require "rack"
require "shack"
require "benchmark/ips"

# Idea from [here](http://www.schneems.com/2014/10/31/benchmarking-rack-middleware.html)
# Thanks @schneems
noop = -> (_env) { [200, { "Content-Type" => "text/html" }, ["hello"]] }
middleware = Shack::Middleware.new(noop, "abc123")

request = Rack::MockRequest.new(middleware)
noop_request = Rack::MockRequest.new(noop)

Benchmark.ips do |x|
  x.config(time: 5, warmup: 5)
  x.report("With Shack") { request.get("/")  }
  x.report("With noop")  { noop_request.get("/") }
  x.compare!
end

# Current results:
#
# Calculating -------------------------------------
#           With Shack   205.000  i/100ms
#            With noop   446.000  i/100ms
# -------------------------------------------------
#           With Shack      2.522k (±23.8%) i/s -     10.455k
#            With noop      6.528k (±21.5%) i/s -     28.098k
#
# Comparison:
#            With noop:     6528.4 i/s
#           With Shack:     2521.7 i/s - 2.59x slower
