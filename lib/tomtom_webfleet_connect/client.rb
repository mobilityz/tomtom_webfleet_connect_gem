module TomtomWebfleetConnect
  class Client

    # Define the same set of accessors as the TomtomWebfleetConnect module
    attr_accessor *Configuration::VALID_CONFIG_KEYS

    def initialize(options={})
      # Merge the config values from the module and those passed
      # to the client.
      merged_options = TomtomWebfleetConnect.options.merge(options)

      # Copy the merged values to this client and ignore those
      # not part of our configuration
      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end

    def send_request(options = {})
      method = TomtomWebfleetConnect::Models::TomtomMethod.find_by_name(options[:action])
      user = TomtomWebfleetConnect::Models::User.avalaible_user(method).first

      TomtomWebfleetConnect.logger.debug 'Api user selected : ' + user.to_json

      if user.nil?
        response = TomtomWebfleetConnect::TomtomResponse.new
        response.http_status_code = 200
        response.http_status_message = 'OK'
        response.response_body = {}
        response.response_code = 8011
        response.response_message = 'request quota reached'
        response.error = true
        response.success = false
      else
        url = get_method_url(method, user)
        request = TomtomWebfleetConnect::TomtomRequest.new
        response =  request.send_request(url, options)
      end

      response
    end


    def estimate_route(start_date, start_latitude, start_longitude, end_latitude, end_longitude)
      options = {
          action: 'calcRouteSimpleExtern',
          use_traffic: 0,
          start_day: TomtomWebfleetConnect.date_to_tomtom_day(start_date),
          start_time: TomtomWebfleetConnect.date_to_tomtom_time(start_date),
          start_latitude: TomtomWebfleetConnect.format_lng_lat_to_tomtom(start_latitude),
          start_longitude: TomtomWebfleetConnect.format_lng_lat_to_tomtom(start_longitude),
          end_latitude: TomtomWebfleetConnect.format_lng_lat_to_tomtom(end_latitude),
          end_longitude: TomtomWebfleetConnect.format_lng_lat_to_tomtom(end_longitude)
      }

      response = send_request(options)

      if response.success
        response.response_body[0][:time] = response.response_body[0][:time].sub('PT', '').sub('S', '').to_i
      end
      return response
    end


    def get_url_with_parameters
      endpoint + "?account=#{self.account}&apikey=#{self.api_key}&lang=#{self.lang}&useISO8601=#{self.use_ISO8601}&useUTF8=#{self.use_UTF8}&outputformat=#{self.format}"
    end

    def get_base_url(user)
      return get_url_with_parameters + "&username=#{user.name}&password=#{user.password}"
    end

    def get_method_url(method, user)
      counter = TomtomWebfleetConnect::Models::MethodCounter.where('user_id = ? and tomtom_method_id = ?', user.id, method.id).first
      if counter.nil?
        counter = TomtomWebfleetConnect::Models::MethodCounter.create user_id: user.id, tomtom_method_id: method.id
        counter.start_counter
      else
        if counter.counter_can_be_reset?
          counter.reset_counter
          counter.start_counter
        else
          counter.increment_counter
        end
      end
      TomtomWebfleetConnect.logger.debug 'Counter state of selected user for ' + method.name + ' method : ' + counter.to_json
      get_base_url(user) + "&action=#{method.name}"
    end

  end # Client

end