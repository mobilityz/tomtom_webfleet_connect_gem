require 'httparty'
require 'rack'

module TomtomWebfleetConnect
  
  ##
  # This class represents the formated tomtom request
  class TomtomRequest

    attr_reader :request_url, :response 
    
    def initialize(format = TomtomWebfleetConnect::TomtomResponse::FORMATS::JSON)
      @response = TomtomWebfleetConnect::TomtomResponse.new(format)
      @request_url = String.new
    end

    def to_s
      "<-- TomtomRequest\nrequest_url: #{request_url}\nresponse: #{response}\n-->"
    end

    def send_request(url, options = {})
      @request_url = add_options_to_url(url, options.except(:action))
      puts @request_url
      response_tomtom = HTTParty.get(@request_url)
      #puts response_tomtom
      @response = @response.format_response(response_tomtom)
      # puts @response.to_json
      return @response
    end

    private
      def add_options_to_url(url, options = {})
        options.map do |option, value|
          if value.is_a? String
            value = Rack::Utils.escape(value)
          end
          url << "&#{option}=#{value}"
        end
        return url
      end
  end
end
