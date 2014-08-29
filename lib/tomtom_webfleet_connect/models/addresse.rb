module TomtomWebfleetConnect
  module Models
    class Addresse

      attr_accessor :client,
                    :addrnr, :country, :city, :zip, :street, :longitude, :latitude, :destination

      public

      def initialize(api, params = {})
        @client = api

        @addrnr = params[:addrnr] if params[:addrnr].present?
        @country = params[:country] if params[:country].present?
        @city = params[:city] if params[:city].present?
        @zip = params[:zip] if params[:zip].present?
        @street = params[:street] if params[:street].present?
        @longitude = params[:longitude] if params[:longitude].present?
        @latitude = params[:latitude] if params[:latitude].present?

        generate_destination
      end

      def to_s
        ""
      end

      private

      def generate_destination
        @destination = @city + ", " + @street if not @city.blank? and not @street.blank?
      end

    end
  end
end