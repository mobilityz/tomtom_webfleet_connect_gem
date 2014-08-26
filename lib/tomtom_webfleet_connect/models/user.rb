require 'active_record'

module TomtomWebfleetConnect
  module Models
    class User < ActiveRecord::Base

      self.table_name = "tomtom_webfleet_connect_users"

      attr_accessible :name, :password
       
      validates :name, :password, :presence => true
      #validates_uniqueness_of :name
      #validate :is_valid_tomtom_user?

      has_many :method_counters, :dependent => :delete_all

      #TODO get user with no counter for the method or 
      #  (which have counter for this method and 
      #    (quota less tan max or (quota equal or greater of max and quota delay exceeded))
      #  )
      scope :avalaible_user, ->(method) {includes(:method_counters).where('(tomtom_webfleet_connect_users.id NOT IN (SELECT DISTINCT(user_id) FROM "tomtom_webfleet_connect_method_counters" as counter WHERE counter.tomtom_method_id = ?)) 
                                                                          or (tomtom_webfleet_connect_method_counters.tomtom_method_id = ? and tomtom_webfleet_connect_method_counters.counter is null and tomtom_webfleet_connect_method_counters.counter_start_at is null)
                                                                          or (tomtom_webfleet_connect_method_counters.tomtom_method_id = ? and tomtom_webfleet_connect_method_counters.counter < ?)
                                                                          or (tomtom_webfleet_connect_method_counters.tomtom_method_id = ? and tomtom_webfleet_connect_method_counters.counter >= ? and tomtom_webfleet_connect_method_counters.counter_start_at < ?)',
                                                                          method.id, method.id, method.id, (method.quota ), method.id, (method.quota) , DateTime.now - method.quota_delay.minutes)}
       
      #not used
      def get_base_url(api)
        #TomtomWebfleetConnect::API
        return api.get_url_with_parmeters + "&username=#{name}" + "&password=#{password}" 
      end

      #not used yet
      #valid existance of user, and valid password on tomtom webfleet
      def is_valid_tomtom_user?(api)
        #FIXME
        url = api.get_url_with_parmeters + "&username=#{name}" + "&password=#{password}"
        request = TomtomWebfleetConnect::TomtomRequest.new
        response = request.send_request(url)
        #return 1101,User invalid (does not exist) if invalid
        response.response_code == 1101 ? false : true
      end

    end
  end
end