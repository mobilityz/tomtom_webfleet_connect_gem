module TomtomWebfleetConnect
  class API
    attr_accessor :key, :account, :lang, :use_ISO8601, :use_UTF8, :response_format
    
    def initialize(key = nil, account = nil, default_parameters = {})

      @key = key || self.key
      @key = @key.strip if @key
      
      @account = account || self.account
      @account = @account.strip if @account
      
      @lang = default_parameters.delete(:lang) || self.lang
      @use_ISO8601 = default_parameters.delete(:use_ISO8601) || self.use_ISO8601
      @use_UTF8 = default_parameters.delete(:use_UTF8) || self.use_UTF8
      @response_format = default_parameters.delete(:response_format) || self.response_format
      
      @default_params = {key: @key, account: @account}.merge(default_parameters)
    end


    def send_request(options = {})
      method = TomtomWebfleetConnect::Models::TomtomMethod.find_by_name(options[:action])
      user = TomtomWebfleetConnect::Models::User.avalaible_user(method).first

      if user.nil?
        response = TomtomWebfleetConnect::TomtomResponse.new(@response_format)
        response.http_status_code = 200
        response.http_status_message = 'OK'
        response.response_body = {}
        response.response_code = 8011
        response.response_message = 'request quota reached'
        response.error = true
        response.success = false
      else
        url = get_method_url(method, user)
        request = TomtomWebfleetConnect::TomtomRequest.new(@response_format)
        response =  request.send_request(url, options)
      end

      response
    end


    def estimate_route(start_date, start_latitude, start_longitude, end_latitude, end_longitude)
      options = {
        action: 'calcRouteSimpleExtern',
        use_traffic: 0,
        start_day: date_to_tomtom_day(start_date),
        start_time: date_to_tomtom_time(start_date),
        start_latitude: format_lng_lat_to_tomtom(start_latitude),
        start_longitude: format_lng_lat_to_tomtom(start_longitude),
        end_latitude: format_lng_lat_to_tomtom(end_latitude),
        end_longitude: format_lng_lat_to_tomtom(end_longitude)
      }

      response = send_request(options)
      
      if response.success
        response.response_body[0][:time] = response.response_body[0][:time].sub('PT', '').sub('S', '').to_i
      end
      return response
    end



    #private

    def get_root_url
      'https://csv.business.tomtom.com/extern'
    end
    
    def get_url_with_parameters
      get_root_url + '?' + "account=#{self.account}" + "&apikey=#{self.key}" + "&lang=#{self.lang}" + "&useISO8601=#{self.use_ISO8601}" + "&useUTF8=#{self.use_UTF8}" + "&outputformat=#{self.response_format}"
    end

    def get_base_url(user)
        return get_url_with_parameters + "&username=#{user.name}" + "&password=#{user.password}"
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
      get_base_url(user) + "&action=#{method.name}"
    end

    #Formaters
    def format_lng_lat_to_tomtom(number)
      return (number * 10**6).round
    end

    #logger.info {date.strftime("%FT%T.%L%:z") }
    #start_datetime=#{estimate.departure.strftime("%FT%TZ")}&
    #logger.info { "iso8601 : " + journey.estimate.departure.iso8601.to_s }
    
    def date_to_tomtom_day(date)
      return date.strftime('a').downcase
    end

    def date_to_tomtom_time(date)
      return date.strftime('%T')
    end
    #FIXME pb sur la date passé en paramètre
    def date_to_tomtom_date(date)
      return date.date.strftime('%FT%TZ')
    end

  end
end