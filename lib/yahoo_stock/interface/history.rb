=begin
params:
 s=stock symbol
 a=month-1
 b=date
 c=year
 d=month-1
 e=date
 f=year
 g=d or w or m
 ignore=.csv

=end

module YahooStock
   # ==DESCRIPTION:
   # 
   # Class to generate the right url and interface with yahoo to get history of a stock
   #
  class Interface::History < Interface

    class HistoryError < RuntimeError ; end
    
    attr_reader :stock_symbol, :start_date, :end_date, :type
    
    # The options parameter expects a hash with 4 key value pairs
    #
    # :stock_symbol => 'goog', :start_date => Date.today-30,
    # :end_date => Date.today-10, :type => :weekly
    #
    # The type option accepts :daily, :monthly, :weekly and :dividend values
    #
    # The type key is optional, if not used then by default uses :daily
    #
    # and provides daily history for the specified date range
    #
    def initialize(options)
      @base_url = BASE_URLS[:history]
      validate_keys(options)
      
      @stock_symbol = options[:stock_symbol]
      @start_date   = options[:start_date]
      @end_date     = options[:end_date]
      @type     = options[:type].nil? ? :daily : options[:type].to_sym
      
      validate_type_values(options[:type]) if options[:type]
      validate_stock_symbol(options)
      validate_start_date(options)
      validate_end_date(options)
      validate_history_range
    end
    
    # Make sure that stock symbol is not nil or an empty string before setting it
    def stock_symbol=(stock_symbol)
      validate_stock_symbol_attribute(stock_symbol)
      @stock_symbol = stock_symbol
    end
    
    # Before setting start date
    #   - Make sure that it is of type date
    #   - Make sure that it is before the end date
    def start_date=(start_date)
      validate_start_date_type(start_date)
      validate_history_range(start_date)
      @start_date = start_date
    end
    
    # Before setting end date
    #   - Make sure that it is of type date
    #   - Make sure that it is after the start date
    def end_date=(end_date)
      validate_end_date_type(end_date)
      validate_history_range(start_date, end_date)
      @end_date = end_date
    end
    
    # Set type to specify whether daily, weekly, monthly or dividend history required
    def type=(type)
      validate_type_values(type)
      @type = type
    end
    
    # Generate full uri with the help of uri method of the superclass
    def uri
      history_type = case type
                       when :daily     then 'd'
                       when :weekly    then 'w'
                       when :monthly   then 'm'
                       when :dividend  then 'v'
                     end
      @uri_parameters = {:a => sprintf("%02d", start_date.month-1), :b => start_date.day, 
                         :c => start_date.year, :d => sprintf("%02d", end_date.month-1),
                         :e => end_date.day, :f => end_date.year, :s => stock_symbol,
                         :g => history_type, :ignore => '.csv'}
      super()  
    end

    # Get uri content with the help of get method of the super class
    def get
      if stock_symbol.nil? || start_date.nil? || end_date.nil?
        raise HistoryError, 'Cannot send request unless all parameters, ie stock_symbol, start and end date are present'
      end
      if !(start_date.is_a?(Date) || end_date.is_a?(Date))
        raise HistoryError, 'Start and end date should be of type Date'
      end
      uri
      super()
    end
    
    private
    
    def validate_type_values(type_value=type)
      valid_values = [:daily, :weekly, :monthly, :dividend]
      unless valid_values.include?(type_value)
        raise HistoryError, "Allowed values for type are #{valid_values.join(', ')}"
      end
    end
    
    def validate_stock_symbol(options)
      unless options.keys.include?(:stock_symbol)
        raise HistoryError, ':stock_symbol key is not present in the parameter hash'
      end
      validate_stock_symbol_attribute
    end
    
    def validate_stock_symbol_attribute(symbol=stock_symbol)
      if symbol.nil? || symbol.empty?
        raise HistoryError, ':stock_symbol value cannot be nil or blank'
      end
    end
    
    def validate_start_date(options)
      validate_date_options(:start_date, options)
      validate_start_date_type
    end
    
    def validate_end_date(options)
      validate_date_options(:end_date, options)
      validate_end_date_type
    end
    
    def validate_history_range(s_date = start_date, e_date = end_date)
      if s_date >= Date.today
        raise HistoryError, "Start date must be in the past"
      end
      if e_date >= Date.today
        raise HistoryError, "End date must be in the past"
      end
      if e_date < s_date
        raise HistoryError, "End date must be greater than the start date"
      end
    end
    
    def validate_end_date_type(e_date=end_date)
      unless e_date.is_a?(Date)
        raise HistoryError, "End date must be of type Date"
      end
    end
    
    def validate_start_date_type(s_date=start_date)
      unless s_date.is_a?(Date)
        raise HistoryError, "Start date must be of type Date"
      end
    end
    
    def validate_date_options(date_type, options)
      unless options.keys.include?(date_type)
        raise HistoryError, ":#{date_type} key is not present in the parameter hash"
      end
      
      if options[date_type].nil? || options[date_type].to_s.empty?
        raise HistoryError, ":#{date_type} value cannot be blank"
      end
    end
    
    def validate_keys(options)
      valid_keys   = [:stock_symbol, :start_date, :end_date, :type]
      invalid_keys = []
      options.keys.each{|key| invalid_keys << key unless valid_keys.include?(key) }
      unless invalid_keys.length.zero?
        raise HistoryError, "An invalid key '#{invalid_keys.join(',')}' is passed in the parameters. Allowed keys are #{valid_keys.join(', ')}"
      end
    end
    
  end
  
end