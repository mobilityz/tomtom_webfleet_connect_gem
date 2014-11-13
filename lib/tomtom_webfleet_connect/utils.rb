module TomtomWebfleetConnect
  module Utils
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