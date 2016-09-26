ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'

require_relative '../app.rb'
require 'mocha'
require 'mocha/setup'
require 'mocha/test_unit'
require 'mocha/any_instance_method'
require 'mocha/mini_test'
