module TomtomWebfleetConnect
  module Models
    class TomtomDate

      attr_accessor :range_pattern, :rangefrom_string, :rangeto_string, :year, :month, :day

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
          @year= Time.now.year
          @month= Time.now.month
          @day= Time.now.day
        else
          @range_pattern = params[:range_pattern] if params[:range_pattern].present?
          @rangefrom_string = params[:rangefrom_string] if params[:rangefrom_string].present?
          @rangeto_string = params[:rangeto_string] if params[:rangeto_string].present?
          @year = params[:year] if params[:year].present?
          @month = params[:mouth] if params[:mouth].present?
          @day = params[:day] if params[:day].present?
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

      # ______________________________________________________
      # INSTANCE METHOD
      # ______________________________________________________

      def to_s
        ""
      end

      def to_hash
        object_hash= Hash.new

        object_hash = object_hash.merge({range_pattern: @range_pattern}) unless @range_pattern.blank?
        object_hash = object_hash.merge({rangefrom_string: @rangefrom_string}) unless @rangefrom_string.blank?
        object_hash = object_hash.merge({rangeto_string: @rangeto_string}) unless @rangeto_string.blank?
        object_hash = object_hash.merge({year: @year}) unless @year.blank?
        object_hash = object_hash.merge({mouth: @mouth}) unless @mouth.blank?
        object_hash = object_hash.merge({day: @day}) unless @day.blank?

        return object_hash
      end


    end
  end
end