module TomtomWebfleetConnect
  module Models
    class TomtomDate

      attr_accessor :range_pattern, :rangefrom_string, :rangeto_string, :year, :month, :day,
                    :datetime, :hour, :minute, :second

      public

      module RANGE_PATTERN
        ALL = [
            ['today', TODAY = 'd0'],
            ['Yesterday', YESTERDAY = 'd-1'],
            ['Two days ago', TWO_DAY_AGO = 'd-2'],
            ['Three days ago', THREE_DAY_AGO = 'd-3'],
            ['Four days ago', FOUR_DAY_AGO = 'd-4'],
            ['Five days ago', FIVE_DAY_AGO = 'd-5'],
            ['Six days ago', SIX_DAY_AGO = 'd-6'],
            ['Current week', CURRENT_WEEk = 'w0'],
            ['Last week', LAST_WEEK = 'w-1'],
            ['Two weeks ago', TWO_WEEKS_AGO = 'w-2'],
            ['Three weeks ago', THREE_WEEKS_AGO = 'w-3'],
            ['Floating week, current day and previous seven days', TODAY_AND_PREVIOUS_WEEK = 'wf0'],
            ['Floating week, the seven calendar days before wf0', ONE_WEEK_BEFORE_TODAY_AND_PREVIOUS_WEEK = 'wf-1'],
            ['Floating week, the seven calendar days before wf-1', TWO_WEEK_BEFORE_TODAY_AND_PREVIOUS_WEEK = 'wf-2'],
            ['Floating week, the seven calendar days before wf-2', THREE_WEEK_BEFORE_TODAY_AND_PREVIOUS_WEEK = 'wf-3'],
            ['Current month', CURRENT_MONTH = 'm0'],
            ['Last month', LAST_MONTH = 'm-1'],
            ['Two months ago', TWO_MONTH_AGO = 'm-2'],
            ['Three months ago', THREE_MONTH_AGO = 'm-3'],
            ['User-defined range', USER_DEFINED_RANGE = 'ud']
        ]
      end

      def initialize(params = {})

        if params.blank?
          @range_pattern = RANGE_PATTERN::TODAY
          @year= DateTime.now.year
          @month= DateTime.now.month
          @day= DateTime.now.day
          @datetime = DateTime.new(Date.today.year,Date.today.month,Date.today.day,DateTime.now.hour,DateTime.now.minute,DateTime.now.second,'+1')
        # elsif not params[:range_pattern].present?
        #   @year = params[:year].to_i if params[:year].present?
        #   @month = params[:month].to_i if params[:month].present?
        #   @day = params[:day].to_i if params[:day].present?
        #
        #   @range_pattern = RANGE_PATTERN::USER_DEFINED_RANGE
        #   @rangefrom_string = "#{params[:year]}-#{params[:month]}-#{params[:day]}T00 : 00 : 00"
        #   @rangeto_string = "#{params[:year]}-#{params[:month]}-#{params[:day]}T23 : 59 : 59"

        else
          @range_pattern = params[:range_pattern] if params[:range_pattern].present?
          @rangefrom_string = params[:rangefrom_string] if params[:rangefrom_string].present?
          @rangeto_string = params[:rangeto_string] if params[:rangeto_string].present?

          @year = params[:year].present? ? params[:year].to_i : DateTime.now.year
          @month = params[:month].present? ? params[:month].to_i : DateTime.now.month
          @day = params[:day].present? ? params[:day].to_i : DateTime.now.day

          @hour = params[:hour].present? ? params[:hour].to_i : 0
          @minute = params[:minute].present? ? params[:minute].to_i : 0
          @second = params[:second].present? ? params[:second].to_i : 0

          @datetime = DateTime.new(@year,@month,@day,@hour,@minute,@second,'+1')
        end

      end

      # ______________________________________________________
      # CLASS METHOD
      # ______________________________________________________

      def self.now
        TomtomDate.new
      end

      def self.current_month
        TomtomDate.new({range_pattern: RANGE_PATTERN::CURRENT_MONTH})
      end

      def self.tomorrow
        tomorrow = DateTime.now
        tomorrow = tomorrow.new_offset('+01:00')
        tomorrow += 1
        TomtomDate.new({year: tomorrow.year, month: tomorrow.month, day: tomorrow.day, hour: tomorrow.hour, minute: tomorrow.minute, second: tomorrow.second})
      end

      # ______________________________________________________
      # INSTANCE METHOD
      # ______________________________________________________

      def date_for_create
        @datetime.strftime("%FT%:z")
      end

      def time_for_create
        @datetime.strftime("%T")
      end

      def date_for_show
        @datetime.strftime("%FT%:z")
      end

      def time_for_show
        @datetime.strftime("%T")
      end

      def get_start_journey_datetime
        datetime = DateTime.new(@datetime.year,@datetime.month,@datetime.day,0,0,0,'+01:00')
        datetime.strftime("%FT%T")
      end

      def get_end_journey_datetime
        datetime = DateTime.new(@datetime.year,@datetime.month,@datetime.day,23,59,59,'+01:00')
        datetime.strftime("%FT%T")
      end

      def to_hash
        object_hash= Hash.new

        object_hash = object_hash.merge({range_pattern: @range_pattern}) unless @range_pattern.blank?
        object_hash = object_hash.merge({rangefrom_string: @rangefrom_string}) unless @rangefrom_string.blank?
        object_hash = object_hash.merge({rangeto_string: @rangeto_string}) unless @rangeto_string.blank?
        object_hash = object_hash.merge({year: @year}) unless @year.blank?
        object_hash = object_hash.merge({month: @month}) unless @month.blank?
        object_hash = object_hash.merge({day: @day}) unless @day.blank?

        return object_hash
      end

      def get_range_pattern_full_day
        object_hash= Hash.new

        object_hash = object_hash.merge({range_pattern: @range_pattern})
        object_hash = object_hash.merge({rangefrom_string: get_start_journey_datetime})
        object_hash = object_hash.merge({rangeto_string: get_end_journey_datetime})

        return object_hash
      end

      def get_range_pattern
        {range_pattern: @range_pattern}
      end

      def get_hash_date
        object_hash= Hash.new

        object_hash = object_hash.merge({year: @year}) unless @year.blank?
        object_hash = object_hash.merge({month: @month}) unless @month.blank?
        object_hash = object_hash.merge({day: @day}) unless @day.blank?

        return object_hash
      end

    end
  end
end