module TomtomWebfleetConnect
  module Models
    class Journey

      attr_accessor :start_order, :end_order, :client

      def initialize(api, start_order, end_order)
        @client= api
      end

      def send

      end

      def push

      end

      def cancel

      end

      def delete

      end

      def assign_to(driver)

      end

    end
  end
end