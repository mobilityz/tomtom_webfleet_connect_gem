require 'httparty'
require 'logger'

require 'tomtom_webfleet_connect/version'
require 'tomtom_webfleet_connect/configuration'
require 'tomtom_webfleet_connect/utils'
require 'tomtom_webfleet_connect/client'

require 'tomtom_webfleet_connect/models/user'
require 'tomtom_webfleet_connect/models/order'
require 'tomtom_webfleet_connect/models/method_counter'
require 'tomtom_webfleet_connect/models/tomtom_method'
require 'tomtom_webfleet_connect/tomtom_request'
require 'tomtom_webfleet_connect/tomtom_response'

module TomtomWebfleetConnect

  extend Configuration
  extend Utils

  class << self
    attr_accessor :logger
  end

end
