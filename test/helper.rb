# coding: utf-8

require "minitest/autorun"
require "minitest/pride"
require "mocha"
require "pry"

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "shack"
