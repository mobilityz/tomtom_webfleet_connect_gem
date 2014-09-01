module TomtomWebfleetConnect
  module Models
    class TomtomObject

      attr_accessor :objectno, :objectname, :objectuid,
                    :client

      public

      def initialize(api, params = {})
        @client = api
        @objectno = params[:objectno] if params[:objectno].present?
        @objectname = params[:objectname] if params[:objectname].present?
        @objectuid = params[:objectuid] if params[:objectuid].present?
      end

      def to_s
        string= ""

        string += ":objectno=>#{@objectno}" unless @objectno.blank?
        string += ":objectname=>#{@objectname}" unless @objectname.blank?
        string += ":objectuid=>#{@objectuid}" unless @objectuid.blank?

        return string
      end

      def to_hash
        object_hash = {}

        if not @objectno.blank? and @objectuid.blank?
          object_hash = object_hash.merge({objectno: @objectno})
          object_hash = object_hash.merge({objectname: @objectname}) unless @objectname.blank?
        elsif @objectno.blank? and not @objectuid.blank?
          object_hash = object_hash.merge({objectuid: @objectuid})
        elsif not @objectno.blank? and not @objectuid.blank?
          object_hash = object_hash.merge({objectno: @objectno})
          object_hash = object_hash.merge({objectuid: @objectuid})
        end

        object_hash = object_hash.merge({objectname: @objectname}) unless @objectname.blank?

        return object_hash
      end

    end
  end
end