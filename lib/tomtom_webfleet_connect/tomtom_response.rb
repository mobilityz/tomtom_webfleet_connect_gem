module TomtomWebfleetConnect
  
  require 'csv'

  ##
  # This class represents the formated tomtom response
  class TomtomResponse

    attr_accessor :http_status_code, :http_status_message, :response_code, :response_message, :response_body, :error, :success
    
    def initialize
      
    end
    
    def has_operation_response_code?
      not @response_code.empty?
    end

    def format_response(response)
      
      if !response.body.empty?
        @http_status_message = response.message
        @http_status_code = response.code

        if response.code == 200
          lines = CSV.parse(response, :col_sep => ";")
          if is_an_operation_response_code?(lines)
            code, message = lines.first.first.split(/,/)
            @response_body = {}
            @response_code = code.to_i
            @response_message = message
            @error = true
            @success = false
          else
            parameters = lines[0].collect! {|row| row.to_sym}
            lines.shift
            if lines.count > 1
              @response_body = []
              lines.each do |line|
                @response_body << Hash[parameters.zip line]
              end
            else
              @response_body = Hash[parameters.zip lines[0]]
            end
            @response_code = nil
            @response_message = ''
            @error = false
            @success = true
          end
        else
          @error = true
          @success = false
        end
      else
        #All methods that transmit data, e.g. all send ... methods, return nothing on successful completion, that is the response is empty
        @http_status_code = 200
        @http_status_message = "OK"
        @response_body = {}
        @response_code = nil
        @response_message = ''
        @error = false
        @success = true
      end
      return self
    end

    private
      def is_an_operation_response_code?(response)
        return response.first.size == 1 ? true : false
      end
  end
end
