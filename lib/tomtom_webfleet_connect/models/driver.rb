module TomtomWebfleetConnect
  module Models
    class Driver

      attr_accessor :client,
                    :driverno, :drivername, :drivertelmobile, :driveruid

      public

      def initialize(api, params = {})
        @client = api

        @driverno = params[:driverno] if params[:driverno].present?
        @drivername = params[:drivername] if params[:drivername].present?
        @drivertelmobile = params[:drivertelmobile] if params[:drivertelmobile].present?
        @driveruid = params[:driveruid] if params[:driveruid].present?
      end

      def to_s
        ""
      end

    end
  end
end