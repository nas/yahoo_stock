=begin

base url = http://ichart.finance.yahoo.com/table.csv

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
require 'net/http'
module YahooStock
  class History
    
    class HistoryError < RuntimeError; end
    
    attr_reader :stock_symbol, :start_date, :end_date, :interval
    
    def initialize(options)
      unless options.is_a?(Hash)
        raise HistoryError, 'A hash of start_date, end_date and stock_symbol is expected as parameters'
      end
      validate_keys(options)
      
      @stock_symbol = options[:stock_symbol]
      @start_date   = options[:start_date]
      @end_date     = options[:end_date]
      @interval     = options[:interval].nil? ? :daily : options[:interval].to_sym
      
      validate_interval_values(options[:interval]) if options[:interval]
      validate_stock_symbol(options)
      validate_start_date(options)
      validate_end_date(options)
      validate_history_range
      @base_url = "http://ichart.finance.yahoo.com/table.csv"
    end
    
    def stock_symbol=(stock_symbol)
      validate_stock_symbol_attribute(stock_symbol)
      @stock_symbol = stock_symbol
    end
    
    def start_date=(start_date)
      validate_start_date_type(start_date)
      validate_history_range(start_date)
      @start_date = start_date
    end
    
    def end_date=(end_date)
      validate_end_date_type(end_date)
      validate_history_range(start_date, end_date)
      @end_date = end_date
    end
    
    def interval=(interval)
      validate_interval_values(interval)
      @interval = interval
    end
    
    def send_request
      if stock_symbol.nil? || start_date.nil? || end_date.nil?
        raise HistoryError, 'Cannot send request unless all parameters, ie stock_symbol, start and end date are present'
      end
      if !(start_date.is_a?(Date) || end_date.is_a?(Date))
        raise HistoryError, 'Start and end date should be of type Date'
      end
      response = Net::HTTP.get_response(URI.parse(uri))
      if response.code == '200'
        return response.body
      else
        raise "No historical data found for the stock symbol: #{stock_symbol}"
      end
    end
    
    # Return an array of hashes with latest date first
    # Each array element contains a hash of date, volume traded, opening, closing, high and low prices
    def results
      values = send_request.split(/\n/)
      headers, daily_data = values.partition{|h| h==values[0]}
      headings = headers.first.split(',')
      data = []
      daily_data.each do |datum|
        daily_values = {}
        datum.split(',').each_with_index do |item, i|
          daily_values[headings[i]] = item
        end
        data << daily_values
      end
      data
    end
    
    private
    
    def uri
      frequency = case interval
                    when :daily   : 'd'
                    when :weekly  : 'w'
                    when :monthly : 'm'
                  end
      start_date_param = "a=#{sprintf("%02d", start_date.month-1)}&b=#{start_date.day}&c=#{start_date.year}"
      end_date_param = "d=#{sprintf("%02d", end_date.month-1)}&e=#{end_date.day}&f=#{end_date.year}"
      params="s=#{stock_symbol}&#{start_date_param}&#{end_date_param}&g=#{frequency}&ignore=.csv"
      "#{@base_url}?#{params}"
    end
    
    def validate_interval_values(interval_value=interval)
      valid_values = [:daily, :weekly, :monthly]
      unless valid_values.include?(interval_value)
        raise HistoryError, "Allowed values for interval are #{valid_values.join(', ')}"
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
      valid_keys   = [:stock_symbol, :start_date, :end_date, :interval]
      invalid_keys = []
      options.keys.each{|key| invalid_keys << key unless valid_keys.include?(key) }
      unless invalid_keys.length.zero?
        raise HistoryError, "An invalid key '#{invalid_keys.join(',')}' is passed in the parameters. Allowed keys are #{valid_keys.join(', ')}"
      end
    end
    
  end
end
