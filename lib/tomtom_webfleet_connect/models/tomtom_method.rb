require 'active_record'

module TomtomWebfleetConnect
  module Models
    class TomtomMethod < ActiveRecord::Base

			##
			# name: is the name of tomtom method
    	# quota: is the maximum request in quota_delay
    	# quota_delay: in minutes
    	#

      self.table_name = 'tomtom_webfleet_connect_methods'

      has_many :method_counters

      validates :name, :quota, :quota_delay, :presence => true

      def user_params
        params.require(:tomtom_method).permit(:name, :quota, :quota_delay)
      end

    end
  end
end