module TomtomWebfleetConnect

  require 'csv'

  ##
  # This class represents the formated tomtom response
  class TomtomResponse

    attr_accessor :http_status_code, :http_status_message, :response_code, :response_message, :response_body, :error, :success


    def to_s
      "<-- TomtomResponse\nhttp_status_code: #{@http_status_code}\nhttp_status_message: #{@http_status_message}\nresponse_code: #{@response_code}\nresponse_message: #{response_message}\nresponse_body: #{response_body}\nerror: #{error}\nsuccess: #{success}\n-->\n"
    end

    def has_operation_response_code?
      not @response_code.empty?
    end

    def format_response(response)

      TomtomWebfleetConnect.logger.debug 'reponse :' + response.to_json
      TomtomWebfleetConnect.logger.debug 'code :' + response.code.to_s
      TomtomWebfleetConnect.logger.debug 'message :' + response.message.to_s
      TomtomWebfleetConnect.logger.debug 'header :' + response.headers.to_json

      @response_body = JSON.parse(response.body, {symbolize_names: true})
      @http_status_code = response.code
      @http_status_message = response.message
      @response_code = nil
      @response_message = ''

      if response.code == 200
        if response.headers['x-webfleet-errorcode']
          @response_code = response.headers['x-webfleet-errorcode'].to_i
          @response_message = response.headers['x-webfleet-errormessage']
          @error = true
          @success = false
          TomtomWebfleetConnect.logger.error 'response code :' + @response_code.to_s
          TomtomWebfleetConnect.logger.error 'response message :' + @response_message.to_s
        else
          @error = false
          @success = true
        end
      else
        @error = true
        @success = false
        TomtomWebfleetConnect.logger.error 'Error: The HTTP request failed'
        raise StandardError, 'Error: The HTTP request failed'
      end

      self
    end

  end
end
