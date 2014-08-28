

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

      module STATES
        ALL = [
            ['null', NONE = 'null'],
            ['Arrived at destination', ARRIVED_AT_DESTINATION = '202'],
            ['Work started', WORK_STARTED = '203'],
            ['Work finished', WORK_FINISHED = '204'],
            ['Departed from destination', DEPARTED_FROM_DESTINATION = '205']
        ]
      end

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
      attr_accessor :number, :message, :type, :objectno, :api,
                    :state,
                    :contact, :phone_number, :planned_date_execution, :destination_address, :destination_coordinates, :desired_time_arrival, :time_tolerance, :lead_time

      # validates :number, :message, :type, :presence => true

      public

      def initialize(api, number, message, objectno, type= Order::TYPES::SERVICE)
        @api= api
        @number= number[0...20]
        @message= message[0...500]
        @objectno= objectno[0...10]
        @type= type
      end

      def to_s
        "<-- Order\norderid: #{@number}\nordertext: #{@message}\nordertype: #{@type}\n-->\n"
      end

      # ______________________________________________________
      # CLASS METHOD
      # ______________________________________________________

      def self.create(api, objectno, orderid, ordertext)

        order = Order.new(api, orderid, ordertext, objectno)

        TomtomWebfleetConnect::Models::TomtomMethod.create! name: "sendOrderExtern", quota:300, quota_delay: 30
        response= api.send_request(order.sendOrderExtern)

        if response.error
          order=nil
          raise CreateOrderError, "Error #{response.response_code}: #{response.response_message}"
        end

        return order
      end

      def self.create_with_destination(api, objectno, orderid, ordertext, destination_address)

        order = Order.new(api, orderid, ordertext, objectno)
        order.destination_address = destination_address

        TomtomWebfleetConnect::Models::TomtomMethod.create! name: "sendDestinationOrderExtern", quota:300, quota_delay: 30
        response= api.send_request(order.sendDestinationOrderExtern(destination_address))

        if response.error
          order=nil
          raise CreateOrderError, "Error #{response.response_code}: #{response.response_message}"
        end

        return order
      end

      # TODO Find by uid/date/... method -> showOrderReportExtern
      def self.find(api)

      end

      # TODO implement all function
      def self.all(api)

      end

      # TODO implement all function
      def self.all_for_object(api, objectno)
        orders= []

        TomtomWebfleetConnect::Models::TomtomMethod.create! name: "showOrderReportExtern", quota:6, quota_delay: 1
        response= api.send_request(Order.showOrderReportExtern({objectno: objectno}))

      end

      # TODO implement where function with date
      def self.where(api)

      end

      def self.generate_orderid
        o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
        orderid = (0...20).map { o[rand(o.length)] }.join
      end

      # ______________________________________________________
      # INSTANCE METHOD
      # ______________________________________________________

      def cancel
        @api.send_request(cancelOrderExtern(@number))
      end

      def delete
        @api.send_request(deleteOrderExtern(true))
      end

      # TODO implement send function
      # Test si pas deja sent ou cancel ou reject (cf state) sinon envoie
      def send

      end


      # private

      # -------------------------------------
      # WEBFLEET.connect-en-1.21.1 page 80
      # -------------------------------------

      # TODO Implement sendOrderExtern function
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
      # def self.sendOrderExtern(objectno, orderid, ordertext, options = {})
      #   defaults={
      #       action: 'sendOrderExtern',
      #       objectno: objectno[0...10],
      #       orderid: orderid[0...20],
      #       ordertext: ordertext[0...500]
      #   }
      #   options = defaults.merge(options)
      # end

      def sendOrderExtern(options = {})
        defaults={
            action: 'sendOrderExtern',
            objectno: @objectno,
            orderid: @number,
            ordertext: @message
        }
        options = defaults.merge(options)
      end

      # TODO Implement sendDestinationOrderExtern function
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
      # def self.sendDestinationOrderExtern(objectno, orderid, ordertext, options = {})
      #   defaults={
      #       action: 'sendDestinationOrderExtern',
      #       objectno: objectno[0...10],
      #       orderid: orderid[0...20],
      #       ordertext: ordertext[0...500]
      #   }
      #   options = defaults.merge(options)
      # end

      def sendDestinationOrderExtern(options = {})
        defaults={
            action: 'sendDestinationOrderExtern',
            objectno: @objectno,
            orderid: @number,
            ordertext: @message
        }
        options = defaults.merge(options)
      end

      # TODO Implement updateOrderExtern function
      # Updates an order that was submitted with sendOrderExtern.
      #
      # Request limits 300 requests / 30 minutes
      #
      # updateOrderExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      # def self.updateOrderExtern(orderid, ordertext, options = {})
      #   defaults={
      #       action: 'updateOrderExtern',
      #       orderid: orderid[0...20],
      #       ordertext: ordertext[0...500]
      #   }
      #   options = defaults.merge(options)
      # end

      def updateOrderExtern(options = {})
        defaults={
            action: 'updateOrderExtern',
            orderid: @number,
            ordertext: @message
        }
        options = defaults.merge(options)
      end

      # TODO Implement updateDestinationOrderExtern function
      # Updates an order that was submitted with sendDestinationOrderExtern or with insertDestinationOrderExtern.
      #
      # Request limits 300 requests / 30 minutes
      #
      # updateDestinationOrderExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      # def self.updateDestinationOrderExtern(orderid, options = {})
      #   defaults={
      #       action: 'updateDestinationOrderExtern',
      #       orderid: orderid[0...20]
      #   }
      #   options = defaults.merge(options)
      # end

      def updateDestinationOrderExtern(options = {})
        defaults={
            action: 'updateDestinationOrderExtern',
            orderid: @number,
            ordertext: @message
        }
        defaults_with_addr = defaults.merge(@destination_address)
        options = defaults_with_addr.merge(options)
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
      def insertDestinationOrderExtern(orderid, ordertext, ordertype = Order::TYPES::SERVICE, options = {})
        defaults={
            action: 'insertDestinationOrderExtern',
            orderid: orderid[0...20],
            ordertext: ordertext[0...500],
            ordertype: ordertype
        }
        options = defaults.merge(options)
      end

      # TODO Implement cancelOrderExtern function
      # Cancels orders that were submitted using one of sendDestinationOrderExtern,
      # insertDestinationOrderExtern or sendOrderExtern.
      #
      # Request limits 300 requests / 30 minutes
      #
      # cancelOrderExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      # def self.cancelOrderExtern(orderid)
      #   defaults={
      #       action: 'cancelOrderExtern',
      #       orderid: orderid[0...20]
      #   }
      # end

      def cancelOrderExtern
        defaults={
            action: 'cancelOrderExtern',
            orderid: @number
        }
      end

      # TODO Implement assignOrderExtern function
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
      def assignOrderExtern(orderid, options = {})
        defaults={
            action: 'assignOrderExtern',
            orderid: orderid[0...20]
        }
        options = defaults.merge(options)
      end

      # TODO Implement reassignOrderExtern function
      # Reassigns an order that was submitted using one of
      # sendDestinationOrderExtern, insertDestinationOrderExtern or
      # sendOrderExtern to another object. This is done by cancelling the order on the
      # old object that is currently assigned to this order and assigning the new object to
      # the order. The order is then sent to the new object.
      #
      # Request limits 300 requests / 30 minutes
      #
      # reassignOrderExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      def reassignOrderExtern(objectid, orderid,  options = {})
        defaults={
            action: 'reassignOrderExtern',
            objectid: objectid[0...10],
            orderid: orderid[0...20],
        }
        options = defaults.merge(options)
      end

      # TODO Implement deleteOrderExtern function
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
      # def self.deleteOrderExtern(orderid, mark_deleted = false)
      #   defaults={
      #       action: 'deleteOrderExtern',
      #       orderid: orderid[0...20],
      #       mark_deleted: (mark_deleted ? '1' : '0' )
      #   }
      # end

      def deleteOrderExtern(deleted_within_webfleet = false)
        defaults={
            action: 'deleteOrderExtern',
            orderid: @number,
            mark_deleted: (deleted_within_webfleet ? '1' : '0' )
        }
      end

      # TODO Implement clearOrdersExtern function
      # Removes all orders from the device and optionally marks them as deleted in
      # WEBFLEET.
      #
      # Request limits 300 requests / 30 minutes
      #
      # clearOrdersExtern requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      def clearOrdersExtern(objectno, mark_deleted = false)
        defaults={
            action: 'clearOrdersExtern',
            objectno: objectno[0...10],
            mark_deleted: (mark_deleted ? '1' : '0' )
        }
        options = defaults.merge(options)
      end

      # TODO Implement showOrderReportExtern function
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
        options = defaults.merge(options)
      end

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
        options = defaults.merge(options)
      end


      end
  end

  class CreateOrderError < StandardError
  end
end