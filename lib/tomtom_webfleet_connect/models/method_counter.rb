require 'active_record'

module TomtomWebfleetConnect
  module Models
    class MethodCounter < ActiveRecord::Base
      
      self.table_name = "tomtom_webfleet_connect_method_counters"

      # module METHODS
        
      #   ##
      #   # quota is the maximum request in quota_delay
      #   # quota_delay in minutes
      #   #
      #   #DEPRECATED replaced by method model
      #   ALL  = [
      #     #Message queus
      #     ['Create queue extern', QUEUE_EXTERN_CREATE = {method: 'createQueueExtern', quota: 10, quota_delay: 24 * 60}],
      #     ['Delete queue extern', QUEUE_EXTERN_DELETE = {method: 'deleteQueueExtern', quota: 10, quota_delay: 24 * 60}],
      #     ['Pop queue messages extern', QUEUE_MESSAGES_EXTERN_POP = {method: 'popQueueMessagesExtern', quota: 10, quota_delay: 1}],
      #     ['Ack queue messages extern', QUEUE_MESSAGES_EXTERN_ACK = {method: 'ackQueueMessagesExtern', quota: 10, quota_delay: 1}],
      #     #Objects
      #     ['Show object report extern', OBJECT_REPORT_EXTERN_SHOW = {method: 'showObjectReportExtern', quota: 6, quota_delay: 1}],
      #     ['Show vehicle report extern', VEHICLE_REPORT_EXTERN_SHOW = {method: 'showVehicleReportExtern', quota: 10, quota_delay: 1}],
      #     ['Show nearest vehicles', NEAREST_VEHICLES_SHOW = {method: 'showNearestVehicles', quota: 10, quota_delay: 1}],
      #     #Orders
      #     ['Send destination order extern', DESTINATION_ORDER_EXTERN_SEND = {method: 'sendDestinationOrderExtern', quota: 300, quota_delay: 30}],
      #     ['Insert destination order extern', DESTINATION_ORDER_EXTERN_INSERT = {method: 'insertDestinationOrderExtern', quota: 300, quota_delay: 30}],
      #     ['Cancel order extern', ORDER_EXTERN_CANCEL = {method: 'cancelOrderExtern', quota: 300, quota_delay: 30}],
      #     ['Assign order extern', ORDER_EXTERN_ASSIGN = {method: 'assignOrderExtern', quota: 300, quota_delay: 30}],
      #     ['Delete order extern', ORDER_EXTERN_DELETE = {method: 'deleteOrderExtern', quota: 300, quota_delay: 30}],
      #     #Drivers
      #     ['Show driver report extern', DRIVER_REPORT_EXTERN_SHOW = {method: 'showDriverReportExtern', quota: 10, quota_delay: 1}],
      #     ['Insert driver extern', DRIVER_EXTERN_INSERT = {method: 'insertDriverExtern', quota: 10, quota_delay: 1}],
      #     #Geocoding and routing
      #     ['Calculate route simple extern', ROUTE_SIMPLE_EXTERN_CALC = {method: 'calcRouteSimpleExtern', quota: 6, quota_delay: 1}],
      #   ]
      # end

      attr_accessible :user_id, :tomtom_method_id, :counter, :counter_start_at
      
      validates :counter, numericality: { only_integer: true }, :allow_nil => true
      validates_uniqueness_of :user_id, :scope => :tomtom_method_id
      validates :user_id, :tomtom_method_id, :presence => true
      
      belongs_to :user
      belongs_to :tomtom_method
      
      ##
      # return true if the counter can be reset
      def counter_can_be_reset?
        if @counter_start_at.nil?
          false
        else
          DateTime.now > @counter_start_at + @tomtom_method.quota_delay.minutes
        end
      end
      
      ##
      # Reset counter to zero
      def reset_counter
        self.update_attribute(:counter, nil)
        self.update_attribute(:counter_start_at, nil)
      end

      ##
      # Start counter on first usage of method
      def start_counter
        self.update_attribute(:counter, 1)
        self.update_attribute(:counter_start_at, DateTime.now)
      end

      def increment_counter
        if @counter.nil?
          start_counter
        else
          self.update_attribute(:counter, @counter + 1)
        end
      end

      #DEPRECATED
      # def self.search_method_constant(method)
      #   METHODS::ALL.collect do |constant|
      #     if constant.second[:method] == method
      #       return constant
      #     end
      #   end
      # end
       
    end
  end
end