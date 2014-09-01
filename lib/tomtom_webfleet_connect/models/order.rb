require 'tomtom_webfleet_connect/models/address'
require 'tomtom_webfleet_connect/models/tomtom_object'
require 'tomtom_webfleet_connect/models/driver'
require 'tomtom_webfleet_connect/models/tomtom_date'

module TomtomWebfleetConnect
  module Models
    class Order

      module TYPES
        ALL = [
            ['Service', SERVICE = '1'],
            ['PickUp', PICKUP = '2'],
            ['Delivery', DELIVERY = '3']
        ]
      end

      # module STATUSES
      #   ALL = [
      #       ['', NONE = ''],
      #       ['Accepted', ACCEPTED = 'Accepted'],
      #       ['Rejected', REJECTED = 'Rejected'],
      #       ['Canceled', CANCELED = 'Canceled'],
      #       ['Saved for later', SAVED_FOR_LATER = 'SavedForLater']
      #   ]
      # end

      # module STATES
      #   ALL = [
      #       ['null', NONE = 'null'],
      #       ['Arrived at destination', ARRIVED_AT_DESTINATION = '202'],
      #       ['Work started', WORK_STARTED = '203'],
      #       ['Work finished', WORK_FINISHED = '204'],
      #       ['Departed from destination', DEPARTED_FROM_DESTINATION = '205']
      #   ]
      # end

      module AUTOMATIONS
        ALL = [
            ['accept the order', ACCEPT_ORDER = '1'],
            ['start the order', START_ORDER = '2'],
            ['navigate to the order destination', NAVIGATE_TO_ORDER_DESTINATION = '3'],
            ['skip displaying the route summary screen', SKIP_DISPLAY_ROUTE = '4'],
            ['delete the order after it has been finished', DELETE_ORDER_AFTER_FINISHED = '5'],
            ['suppress the continue with next order screen', SUPPRESS_CONTINUE_SCREEN = '6']
        ]
      end

      # WEBFLEET.connect-en-1.21.1 page 15
      attr_accessor :orderid, :ordertext, :ordertype, :orderdate,
                    :planned_arrival_time, :estimated_arrival_time, :arrivaltolerance, :delay_warnings, :notify_enabled, :notify_leadtime, :waypointcount,
                    :api, :tomtom_object, :address, :state, :contact, :driver


      public

      def initialize(api, params = {})
        @api = api

        @orderid = params[:orderid][0...20] if params[:orderid].present?
        @ordertext = params[:ordertext][0...500] if params[:ordertext].present?
        @ordertype = params[:ordertype] if params[:ordertype].present?
        @orderdate = params[:orderdate] if params[:orderdate].present?

        @planned_arrival_time = params[:planned_arrival_time] if params[:planned_arrival_time].present?
        @estimated_arrival_time = params[:estimated_arrival_time] if params[:estimated_arrival_time].present?
        @arrivaltolerance = params[:arrivaltolerance] if params[:arrivaltolerance].present?
        @delay_warnings = params[:delay_warnings] if params[:delay_warnings].present?
        @notify_enabled = params[:notify_enabled] if params[:notify_enabled].present?
        @notify_leadtime = params[:notify_leadtime] if params[:notify_leadtime].present?
        @waypointcount = params[:waypointcount] if params[:waypointcount].present?

        if params[:objectno].present? or params[:objectuid].present?
          @tomtom_object = TomtomWebfleetConnect::Models::TomtomObject.new(api, params)
        end

        @address = TomtomWebfleetConnect::Models::Address.new(api, params)
        @state = OrderState.new(params)
        @contact = OrderContact.new(params)
        @driver = TomtomWebfleetConnect::Models::Driver.new(api, params)
      end

      def to_s
        "<-- Order\norderid: #{@orderid}\nordertext: #{@ordertext}\nordertype: #{@ordertype}\n-->\n"
      end

      # ______________________________________________________
      # CLASS METHOD
      # ______________________________________________________

      # Create Order object and send on Webfleet.
      def self.create(api, tomtom_object, params = {})

        order = TomtomWebfleetConnect::Models::Order.new(api, params)
        order.tomtom_object = tomtom_object

        TomtomWebfleetConnect::Models::TomtomMethod.create! name: "sendOrderExtern", quota: 300, quota_delay: 30
        response= api.send_request(order.sendOrderExtern)

        if response.error
          order = nil
          raise CreateOrderError, "Error #{response.response_code}: #{response.response_message}"
        end

        return order
      end

      # Create Order object with destination address and send on Webfleet.
      # The address has to be a hash of the shape: {latitude: '', longitude: '', country: '', zip: '', city: '', street: ''}
      def self.create_with_destination(api, tomtom_object, destination, params = {})

        order = TomtomWebfleetConnect::Models::Order.new(api, params)
        order.tomtom_object = tomtom_object
        order.address= destination

        TomtomWebfleetConnect::Models::TomtomMethod.create! name: "sendDestinationOrderExtern", quota: 300, quota_delay: 30
        response= api.send_request(order.sendDestinationOrderExtern(destination.to_hash))

        if response.error
          order = nil
          raise CreateOrderError, "Error #{response.response_code}: #{response.response_message}"
        else
          return order
        end
      end

      def self.find(api, search_params = {})

        TomtomWebfleetConnect::Models::TomtomMethod.create! name: "showOrderReportExtern", quota: 6, quota_delay: 1
        response= api.send_request(TomtomWebfleetConnect::Models::Order.showOrderReportExtern(search_params))

        if response.error
          order = nil
          raise CreateOrderError, "Error #{response.response_code}: #{response.response_message}"
        else
          order = TomtomWebfleetConnect::Models::Order.new(api, response.response_body)
        end

        return order
      end

      def self.find_with_id(api, orderid)
        TomtomWebfleetConnect::Models::Order.find(api, {orderid: orderid})
      end

      # TODO implement all function
      def self.all(api)

      end


      def self.all_for_object(api, objectno, params = TomtomDate.new({range_pattern: TomtomDate::RANGE_PATTERN::CURRENT_MONTH}).to_hash)
        orders= []
        params = params.blank? ? {objectno: objectno} : params.merge({objectno: objectno})

        TomtomWebfleetConnect::Models::TomtomMethod.create! name: "showOrderReportExtern", quota: 6, quota_delay: 1
        response= api.send_request(TomtomWebfleetConnect::Models::Order.showOrderReportExtern(params))

        if response.error
          raise AllOrderForObjectError, "Error #{response.response_code}: #{response.response_message}"
        else
          response.response_body.each do |line_order|
            orders << TomtomWebfleetConnect::Models::Order.new(line_order)
          end
        end

        return orders

      end

      def self.generate_orderid
        o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
        orderid = (0...20).map { o[rand(o.length)] }.join
      end

      # ______________________________________________________
      # INSTANCE METHOD
      # ______________________________________________________

      def cancel
        TomtomWebfleetConnect::Models::TomtomMethod.create! name: "cancelOrderExtern", quota: 300, quota_delay: 30
        @api.send_request(cancelOrderExtern)
      end

      def delete
        TomtomWebfleetConnect::Models::TomtomMethod.create! name: "deleteOrderExtern", quota: 300, quota_delay: 30
        @api.send_request(deleteOrderExtern(true))
      end

      def update(ordertext, orderautomations= nil)

        TomtomWebfleetConnect::Models::TomtomMethod.create! name: "updateOrderExtern", quota: 300, quota_delay: 30
        response= api.send_request(updateOrderExtern(orderautomations))

        if response.error
          raise UpdateOrderExternError, "Error #{response.response_code}: #{response.response_message}"
        else
          @ordertext= ordertext[0...500]
        end

      end

      def update_destination(address, params)

        old_addr = @address
        @address = address

        TomtomWebfleetConnect::Models::TomtomMethod.create! name: "updateDestinationOrderExtern", quota: 300, quota_delay: 30
        response= api.send_request(updateOrderExtern(updateDestinationOrderExtern(params)))

        if response.error
          @address = old_addr
          raise UpdateDestinationOrderExternError, "Error #{response.response_code}: #{response.response_message}"
        else
          update_params(params)
        end


      end

      def update_params(params)
        @orderid = params[:orderid][0...20] if params[:orderid].present?
        @ordertext = params[:ordertext][0...500] if params[:ordertext].present?
        @ordertype = params[:ordertype] if params[:ordertype].present?
        @orderdate = params[:orderdate] if params[:orderdate].present?

        @planned_arrival_time = params[:planned_arrival_time] if params[:planned_arrival_time].present?
        @estimated_arrival_time = params[:estimated_arrival_time] if params[:estimated_arrival_time].present?
        @arrivaltolerance = params[:arrivaltolerance] if params[:arrivaltolerance].present?
        @delay_warnings = params[:delay_warnings] if params[:delay_warnings].present?
        @notify_enabled = params[:notify_enabled] if params[:notify_enabled].present?
        @notify_leadtime = params[:notify_leadtime] if params[:notify_leadtime].present?
        @waypointcount = params[:waypointcount] if params[:waypointcount].present?
      end


      # private

      # -------------------------------------
      # WEBFLEET.connect-en-1.21.1 page 80
      # -------------------------------------

      # The sendOrderExtern operation allows you to send an order message to an
      # object. The message is sent asynchronously and therefore a positive result of this
      # operation does not indicate that the message was sent to the object successfully.
      #
      # Request limits 300 requests / 30 minutes
      #
      # sendOrderExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      def sendOrderExtern(options = {})
        defaults={
            action: 'sendOrderExtern',
            objectno: @tomtom_object.objectno,
            orderid: @orderid,
            ordertext: @ordertext
        }

        unless options.blank?
          defaults = defaults.merge(options)
        end

        return defaults
      end

      # The sendDestinationOrderExtern operation allows you to send an order
      # message together with target coordinates for a navigation system connected to the
      # in-vehicle unit. The message is sent asynchronously and therefore a positive result
      # of this operation does not indicate that the message was sent to the object
      # successfully.
      #
      # Request limits 300 requests / 30 minutes
      #
      # sendDestinationOrderExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      def sendDestinationOrderExtern(options = {})
        defaults={
            action: 'sendDestinationOrderExtern',
            objectno: @tomtom_object.objectno,
            orderid: @orderid,
            ordertext: @ordertext
        }
        unless options.blank?
          defaults = defaults.merge(options)
        end

        return defaults
      end

      # Updates an order that was submitted with sendOrderExtern.
      #
      # Request limits 300 requests / 30 minutes
      #
      # updateOrderExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      def updateOrderExtern(options = {})
        defaults={
            action: 'updateOrderExtern',
            orderid: @orderid,
            ordertext: @ordertext
        }

        unless options.blank?
          defaults = defaults.merge(options)
        end

        return defaults
      end

      # Updates an order that was submitted with sendDestinationOrderExtern or with insertDestinationOrderExtern.
      #
      # Request limits 300 requests / 30 minutes
      #
      # updateDestinationOrderExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      def updateDestinationOrderExtern(options = {})
        defaults={
            action: 'updateDestinationOrderExtern',
            orderid: @orderid,
            ordertext: @ordertext
        }
        defaults_with_addr = defaults.merge(@address.to_hash)

        unless options.blank?
          defaults_with_addr = defaults_with_addr.merge(options)
        end

        return defaults_with_addr
      end

      # TODO Implement insertDestinationOrderExtern function
      # The insertDestinationOrderExtern operation allows you to transmit an order
      # message to WEBFLEET. The message is not sent and must be manually dispatched
      # to an object within WEBFLEET.
      #
      # Request limits 300 requests / 30 minutes
      #
      # insertDestinationOrderExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      def insertDestinationOrderExtern(options = {})
        defaults={
            action: 'insertDestinationOrderExtern',
            orderid: @orderid,
            ordertext: @ordertext,
            ordertype: @ordertype
        }
        unless options.blank?
          defaults = defaults.merge(options)
        end

        return defaults
      end

      # Cancels orders that were submitted using one of sendDestinationOrderExtern,
      # insertDestinationOrderExtern or sendOrderExtern.
      #
      # Request limits 300 requests / 30 minutes
      #
      # cancelOrderExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      def cancelOrderExtern
        defaults={
            action: 'cancelOrderExtern',
            orderid: @orderid
        }
      end

      # Assigns an existing order to an object and can be used to accomplish the following:
      # - send an order that was inserted before using insertDestinationOrderExtern
      # - resend an order that has been rejected or cancelled
      #
      # Request limits 300 requests / 30 minutes
      #
      # assignOrderExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      def assignOrderExtern(orderautomations = nil)
        defaults={
            action: 'assignOrderExtern',
            orderid: @orderid,
            objectno: @tomtom_object.objectno
        }
        unless orderautomations.blank?
          defaults = defaults.merge(orderautomations)
        end

        return defaults
      end

      # Reassigns an order that was submitted using one of
      # sendDestinationOrderExtern, insertDestinationOrderExtern or
      # sendOrderExtern to another object.
      #
      # This is done by cancelling the order on the old object
      # that is currently assigned to this order and assigning
      # the new object to the order.
      # The order is then sent to the new object.
      #
      # Request limits 300 requests / 30 minutes
      #
      # reassignOrderExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      def reassignOrderExtern(orderautomations = nil)
        defaults={
            action: 'reassignOrderExtern',
            objectid: @tomtom_object.objectno,
            orderid: @orderid,
        }
        unless orderautomations.blank?
          defaults = defaults.merge(orderautomations)
        end

        return defaults
      end

      # Deletes an order from a device and optionally marks it as deleted in WEBFLEET.
      # Supported for the stand-alone TomTom navigation devices connected to
      # WEBFLEET and the TomTom navigation devices connected to LINK 5xx/4xx/3xx.
      #
      # Request limits 300 requests / 30 minutes
      #
      # deleteOrderExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      def deleteOrderExtern(deleted_within_webfleet = false)
        defaults={
            action: 'deleteOrderExtern',
            orderid: @orderid,
            mark_deleted: (deleted_within_webfleet ? '1' : '0')
        }
      end

      # Removes all orders from the device and optionally marks them as deleted in
      # WEBFLEET.
      #
      # Request limits 300 requests / 30 minutes
      #
      # clearOrdersExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      def self.clearOrdersExtern(objectno, deleted_within_webfleet = false)
        defaults={
            action: 'clearOrdersExtern',
            objectno: objectno[0...10],
            mark_deleted: (deleted_within_webfleet ? '1' : '0')
        }
      end

      # Shows a list of orders that match the search parameters. Each entry shows the order
      # details and current status information.
      #
      # Request limits 6 requests / minute
      #
      # showOrderReportExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      # The following other parameters are required if orderid is not indicated:
      # - Date range filter parameters
      #
      def self.showOrderReportExtern(options = {})
        defaults={
            action: 'showOrderReportExtern'
        }
        unless options.blank?
          defaults = defaults.merge(options)
        end

        return defaults
      end

      # def showOrderReportExtern(options = {})
      #   defaults={
      #       action: 'showOrderReportExtern'
      #   }
      #   options = defaults.merge(options)
      # end

      # TODO Implement showOrderWaypoints function
      # This action retrieves the waypoints for an itinerary order with additional information
      # on the validity and state. The waypoints are sorted in the same order which was
      # used when creating the itinerary.
      # Itinerary orders (predefined routes over the air) are supported on all TomTom PRO
      # devices with software version 10.537 or higher.
      #
      # Request limits 10 requests / minute
      #
      # showOrderWaypoints requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      def showOrderWaypoints(options = {})
        defaults={
            action: 'showOrderWaypoints'
        }
        unless options.blank?
          defaults = defaults.merge(options)
        end

        return defaults
      end


    end
  end

  class CreateOrderError < StandardError
  end
  class AllOrderForObjectError < StandardError
  end
  class UpdateOrderExternError < StandardError
  end
  class UpdateDestinationOrderExternError < StandardError
  end

  class OrderState

    attr_accessor :orderstate, :orderstate_time, :orderstate_longitude, :orderstate_latitude, :orderstate_postext, :orderstate_msgtext

    public

    def initialize(params = {})

      @orderstate = params[:orderstate] if params[:orderstate].present?
      @orderstate_time = params[:orderstate_time] if params[:orderstate_time].present?
      @orderstate_longitude = params[:orderstate_longitude] if params[:orderstate_longitude].present?
      @orderstate_latitude = params[:orderstate_latitude] if params[:orderstate_latitude].present?
      @orderstate_postext = params[:orderstate_postext] if params[:orderstate_postext].present?
      @orderstate_msgtext = params[:orderstate_msgtext] if params[:orderstate_msgtext].present?

    end

    def to_s
      ""
    end

  end

  class OrderContact

    attr_accessor :contact, :contacttel

    public

    def initialize(params = {})
      @contact = params[:contact] if params[:contact].present?
      @contacttel = params[:contacttel] if params[:contacttel].present?
    end

    def to_s
      ""
    end

  end


end