module TomtomWebfleetConnect
  module Models
    class OrderState

      attr_accessor :orderstate, :orderstate_time, :orderstate_longitude, :orderstate_latitude, :orderstate_postext, :orderstate_msgtext

      # 0 - Not yet sent
      # 100 - Sent
      # 101 - Received
      # 102 - Read
      # 103 - Accepted
      # 201 - Service order started
      # 202 - Arrived at destination
      # 203 - Work started
      # 204 - Work finished
      # 205 - Departed from destination
      # 221 - Pickup order started
      # 222 - Arrived at pick up location
      # 223 - Pick up started
      # 224 - Pick up finished
      # 225 - Departed from pick up location
      # 241 - Delivery order started
      # 242 - Arrived at delivery location
      # 243 - Delivery started
      # 244 - Delivery finished
      # 245 - Departed from delivery location
      # 298 - Resumed
      # 299 - Suspended
      # 301 - Cancelled
      # 302 - Rejected
      # 401 - Finished
      module STATES
        ALL = [
            ['null', NONE = 'null'],
            ['Not yet sent', NOT_YET_SENT = 0],
            ['Sent', SENT = 100],
            ['Received', RECEIVED = 101],
            ['Read', READ = 102],
            ['Accepted', ACCEPTED = 103],
            ['Service order started', SERVICE_ORDER_STARTED = 201],
            ['Arrived at destination', ARRIVED_AT_DESTINATION = 202],
            ['Work started', WORK_STARTED = 203],
            ['Work finished', WORK_FINISHED = 204],
            ['Departed from destination', DEPARTED_FROM_DESTINATION = 205],
            ['Pickup order started', PICKUP_ORDER_STARTED = 221],
            ['Arrived at pick up location', ARRIVED_AT_PICKUP_LOCATION = 222],
            ['Pick up started', PICKUP_STARTED = 223],
            ['Pick up finished', PICKUP_FINISHED = 224],
            ['Departed from pick up location', DEPARTED_FROM_PICKUP_LOCATION = 225],
            ['Delivery order started', DELIVERY_ORDER_STARTED = 241],
            ['Arrived at delivery location', ARRIVED_AT_DELIVERY_LOCATION = 242],
            ['Delivery started', DELIVERY_STARTED = 243],
            ['Delivery finished', DELIVERY_FINISHED = 244],
            ['Departed from delivery location', DEPARTED_FROM_DELIVERY_LOCATION = 245],
            ['Resumed', RESUMED = 298],
            ['Suspended', SUSPENDED = 299],
            ['Cancelled', CANCELLED = 301],
            ['Rejected', REJECTED = 302],
            ['Finished', FINISHED = 401],
        ]
      end

      public

      def initialize(params = {})

        @orderstate = params[:orderstate].present? ? params[:orderstate].to_i : -1
        @orderstate_time = params[:orderstate_time] if params[:orderstate_time].present?
        @orderstate_longitude = params[:orderstate_longitude] if params[:orderstate_longitude].present?
        @orderstate_latitude = params[:orderstate_latitude] if params[:orderstate_latitude].present?
        @orderstate_postext = params[:orderstate_postext] if params[:orderstate_postext].present?
        @orderstate_msgtext = params[:orderstate_msgtext] if params[:orderstate_msgtext].present?

      end

      def to_s
        ""
      end

      def update(params)
        @orderstate = params[:orderstate].present? ? params[:orderstate].to_i : -1
        @orderstate_time = params[:orderstate_time].present? ? params[:orderstate_time] : nil
        @orderstate_longitude = params[:orderstate_longitude].present? ? params[:orderstate_longitude] : nil
        @orderstate_latitude = params[:orderstate_latitude].present? ? params[:orderstate_latitude] : nil
        @orderstate_postext = params[:orderstate_postext].present? ? params[:orderstate_postext] : nil
        @orderstate_msgtext = params[:orderstate_msgtext].present? ? params[:orderstate_msgtext] : nil
      end

      def get_status_string
        state= STATES::ALL.select { |a| a[1] == @orderstate }
        state[0][0]
      end

    end
  end
end