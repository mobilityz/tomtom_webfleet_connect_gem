module TomtomWebfleetConnect

  require 'csv'

  ##
  # This class represents the formated tomtom response
  class TomtomResponse

    attr_accessor :http_status_code, :http_status_message, :response_code, :response_message, :response_body, :error, :success, :format

    module FORMATS
      ALL = [
          ['csv', CSV = 'csv'],
          ['json', JSON = 'json']
      ]
    end

    def initialize(format = FORMATS::JSON)
      @format = format
    end

    def to_s
      "<-- TomtomResponse\nhttp_status_code: #{@http_status_code}\nhttp_status_message: #{@http_status_message}\nresponse_code: #{@response_code}\nresponse_message: #{response_message}\nresponse_body: #{response_body}\nerror: #{error}\nsuccess: #{success}\n-->\n"
    end

    def has_operation_response_code?
      not @response_code.empty?
    end

    # TODO revoir le format JSon ne fonctionne pas correctement lors des requete
    def format_response(response)

      if @format == FORMATS::CSV
        if response.body.empty?
          #All methods that transmit data, e.g. all send ... methods, return nothing on successful completion, that is the response is empty
          @http_status_code = 200
          @http_status_message = "OK"
          @response_body = {}
          @response_code = nil
          @response_message = ''
          @error = false
          @success = true
        else
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
        end

      elsif @format == FORMATS::JSON
        puts '\nreponse tomtom pure : \n' + response
        @response_body = JSON.parse(response.body, {symbolize_names: true})
        puts '\nreponse tomtom parsee : \n' + @response_body
        @response_body = @response_body #@response_body[0] if @response_body.instance_of? Array

        @http_status_code = response.code
        @http_status_message = response.message

        if @response_body.blank?
          #All methods that transmit data, e.g. all send ... methods, return nothing on successful completion, that is the response is empty
          @response_code = nil
          @response_message = ''
          @error = false
          @success = true
        else
          if response.code == 200
            if @response_body.has_key?(:errorCode)
              @response_code = @response_body[:errorCode]
              @response_message = @response_body[:errorMsg]
              @error = true
              @success = false
            else
              @response_code = nil
              @response_message = ''
              @error = false
              @success = true
            end
          else
            @error = true
            @success = false
            raise StandardError, "Error: The HTTP request failed"
          end
        end
      end

      self
    end

    private
    def is_an_operation_response_code?(response)
      return response.first.size == 1 ? true : false
    end

  end
end
