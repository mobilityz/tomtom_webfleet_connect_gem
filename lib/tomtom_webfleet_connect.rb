require "tomtom_webfleet_connect/version"
require 'tomtom_webfleet_connect/api'
require 'tomtom_webfleet_connect/models/user'
require 'tomtom_webfleet_connect/models/order'
require 'tomtom_webfleet_connect/models/method_counter'
require 'tomtom_webfleet_connect/models/tomtom_method'
require 'tomtom_webfleet_connect/tomtom_request'
require 'tomtom_webfleet_connect/tomtom_response'
require 'logger'

module TomtomWebfleetConnect
  class << self
    attr_accessor :logger
  end
end
