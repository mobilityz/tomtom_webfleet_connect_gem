
module TomtomWebfleetConnect
  module Models
    class Order

      module TYPES
        ALL = [
            ['Delivery', DELIVERY = 'Delivery'],
            ['PickUp', PICKUP = 'PickUp'],
            ['Service', SERVICE = 'Service']
        ]
      end

      module STATUSES
        ALL = [
            ['', NONE = ''],
            ['Accepted', ACCEPTED = 'Accepted'],
            ['Rejected', REJECTED = 'Rejected'],
            ['Canceled', CANCELED = 'Canceled'],
            ['SavedForLater', SAVED_FOR_LATER = 'SavedForLater']
        ]
      end

      # WEBFLEET.connect-en-1.21.1 page 15
      attr_accessible :number, :message, :type, :status,
                      :contact, :phone_number, :planned_date_execution, :destination_address, :destination_coordinates, :desired_time_arrival, :time_tolerance, :lead_time

      validates :number, :message, :type, :presence => true

      # TODO Find by uid/date/... method -> showOrderReportExtern
      # TODO Cancel
      # TODO where avec date


      private

      def sendOrderExtern(orderid, ordertext)

      end

      def sendDestinationOrderExtern

      end

      def updateOrderExtern

      end

      def updateDestinationOrderExtern

      end

      def insertDestinationOrderExtern

      end

      def cancelOrderExtern

      end

      def assignOrderExtern

      end

      def reassignOrderExtern

      end

      def deleteOrderExtern

      end

      def clearOrdersExtern

      end

      def showOrderReportExtern

      end

      def showOrderWaypoints

      end


      end
  end
end