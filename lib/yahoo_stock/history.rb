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

module YahooStock
  class History
    
    class HistoryError < RuntimeError; end
    
    attr_accessor :stock_symbol, :start_date, :end_date
    
    def initialize(options)
      unless options.is_a?(Hash)
        raise HistoryError, 'A hash of start_date, end_date and stock_symbol is expected as parameters'
      end
      @stock_symbol = options[:stock_symbol]
      @start_date = options[:start_date]
      @end_date = options[:end_date]
      
      validate_stock_symbol(options)
      validate_start_date(options)
      validate_end_date(options)
      validate_history_range
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
    
    def uri
    end
    
    def results
    end
    
    private
    
    def validate_stock_symbol(options)
      unless options.keys.include?(:stock_symbol)
        raise YahooStock::History::HistoryError, ':stock_symbol key is not present in the parameter hash'
      end
      validate_stock_symbol_attribute
    end
    
    def validate_stock_symbol_attribute(symbol=stock_symbol)
      if symbol.nil? || symbol.empty?
        raise YahooStock::History::HistoryError, ':stock_symbol value cannot be nil or blank'
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
        raise YahooStock::History::HistoryError, "Start date must be in the past"
      end
      if e_date >= Date.today
        raise YahooStock::History::HistoryError, "End date must be in the past"
      end
      if e_date < s_date
        raise YahooStock::History::HistoryError, "End date must be greater than the start date"
      end
    end
    
    def validate_end_date_type(e_date=end_date)
      unless e_date.is_a?(Date)
        raise YahooStock::History::HistoryError, "End date must be of type Date"
      end
    end
    
    def validate_start_date_type(s_date=start_date)
      unless s_date.is_a?(Date)
        raise YahooStock::History::HistoryError, "Start date must be of type Date"
      end
    end
    
    def validate_date_options(date_type, options)
      unless options.keys.include?(date_type)
        raise YahooStock::History::HistoryError, ":#{date_type} key is not present in the parameter hash"
      end
      
      if options[date_type].nil? || options[date_type].to_s.empty?
        raise YahooStock::History::HistoryError, ":#{date_type} value cannot be blank"
      end
    end
    
  end
end