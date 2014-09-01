module TomtomWebfleetConnect
  module Models
    class Address

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

      # TODO hash not create successful
      def to_hash
        object_hash= Hash.new

        object_hash = object_hash.merge({addrnr: @addrnr}) unless @addrnr.blank?
        object_hash = object_hash.merge({country: @country}) unless @country.blank?
        object_hash = object_hash.merge({city: @city}) unless @city.blank?
        object_hash = object_hash.merge({zip: @zip}) unless @zip.blank?
        object_hash = object_hash.merge({street: @street}) unless @street.blank?
        object_hash = object_hash.merge({longitude: @longitude}) unless @longitude.blank?
        object_hash = object_hash.merge({latitude: @latitude}) unless @latitude.blank?
      end

      private

      def generate_destination
        @destination = @city + ", " + @street if not @city.blank? and not @street.blank?
      end

    end
  end
end