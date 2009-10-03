=begin

Parameter source:
http://www.gummy-stuff.org/Yahoo-data.htm
http://finance.yahoo.com/d/quotes.csv?s=XOM+BBDb.TO+JNJ+MSFT&f=snd1l1yr

=end

module YahooStock
   # ==DESCRIPTION:
   # 
   # Class to generate the right url and interface with yahoo to get daily stock data
   #
  class Interface::Quote < Interface

    class QuoteError < RuntimeError ; end
    
    STD_PARAMETERS = {
      :symbol => 's',
      :name => 'n',
      :last_trade_price_only => 'l1',
      :last_trade_date => 'd1',
      :last_trade_time => 't1',
      :change_with_percent_change => 'c',
      :change => 'c1',
      :previous_close => 'p',
      :change_in_percent => 'p2',
      :open => 'o',
      :day_low => 'g',
      :day_high => 'h',
      :volume => 'v',
      :last_trade_with_time => 'l',
      :day_range => 'm',
      :ticker_trend => 't7',
      :ask => 'a',
      :average_daily_volume => 'a2',
      :bid => 'b',
      :bid_size => 'b4'
    } unless defined?(STD_PARAMETERS)

    EXTENDED_PARAMETERS = {
      :symbol => 's',
      :name => 'n',
      :fifty_two_week_range => 'w',
      :change_from_52_week_low => 'j5',
      :percent_change_from_52_week_low => 'j6',
      :change_from_52_week_high => 'k4',
      :percent_change_from_52_week_high => 'k5',
      :earnings_per_share => 'e',
      :short_ratio => 's7',
      :p_e_ratio => 'r',
      :dividend_pay_date => 'r1',
      :ex_dividend_date => 'q',
      :dividend_per_share => 'd',
      :dividend_yield => 'y',  
      :one_yr_target_price => 't8',
      :market_capitalization => 'j1',  
      :eps_estimate_current_year => 'e7',
      :eps_estimate_next_year => 'e8',
      :eps_estimate_next_quarter => 'e9',
      :peg_ratio => 'r5',
      :price_eps_estimate_current_year => 'r6',
      :price_eps_estimate_next_year => 'r7',
      :book_value => 'b4',
      :ebitda => 'j4',
      :fifty_day_moving_average => 'm3',
      :two_hundred_day_moving_average => 'm4',
      :change_from_200_day_moving_average => 'm5',
      :percent_change_from_200_day_moving_average => 'm6',
      :change_from_50_day_moving_average => 'm7',
      :percent_change_from_50_day_moving_average => 'm8',
      :shares_owned => 's1',
      :price_paid => 'p1',
      :commission => 'c3',
      :holdings_value => 'v1',
      :day_value_change => 'w1',
      :trade_date => 'd2',
      :holdings_gain_percent => 'g1',
      :annualized_gain => 'g3',
      :holdings_gain => 'g4',
      :stock_exchange => 'x',
      :high_limit => 'l2',
      :low_limit => 'l3',
      :notes => 'n4',
      :fifty_two_week_low => 'j',
      :fifty_two_week_high => 'k',
      :more_info => 'i',
    } unless defined?(EXTENDED_PARAMETERS)

    REALTIME_PARAMETERS = {
      :symbol => 's',
      :name => 'n',
      :ask_real_time => 'b2',
      :bid_real_time => 'b3',
      :change => 'c1',
      :change_real_time => 'c6',
      :after_hours_change_real_time => 'c8',
      :holdings_gain_percent_real_time => 'g5',
      :holdings_gain_real_time => 'g6',
      :order_book_real_time => 'i5',
      :market_cap_real_time => 'j3',
      :last_trade_real_time_with_time => 'k1',
      :change_percent_real_time => 'k2',
      :day_range_real_time => 'm2',
      :p_e_ratio_real_time => 'r2',
      :holdings_value_real_time => 'v7',
      :day_value_change_real_time => 'w4',
    } unless defined?(REALTIME_PARAMETERS)
    
    attr_reader :stock_symbols
    
    # The stock_params_hash parameter expects a hash with two key value pairs
    # 
    # :stock_symbols => 'Array of stock symbols'
    # 
    # e.g. :stock_symbols => ['YHOO']
    # 
    # another hash :read_parameters => ['array of values']
    # 
    # e.g. :read_parameters => [:last_trade_price_only, :last_trade_date]
    def initialize(stock_params_hash)
      unless stock_params_hash
        raise QuoteError, 'You must pass a hash of stock symbols and the data you would like to see' 
      end
      if !stock_params_hash[:stock_symbols]  || stock_params_hash[:stock_symbols].length.zero?
        raise(QuoteError, 'No stocks passed')
      end
      if !stock_params_hash[:read_parameters] || stock_params_hash[:read_parameters].length.zero?
        raise QuoteError, 'Read parameters are not provided'
      end
      @stock_symbols        = stock_params_hash[:stock_symbols]
      @yahoo_url_parameters = stock_params_hash[:read_parameters]
      @base_url             = BASE_URLS[:quote]
      add_observer(self)
    end
    
    def stock_symbols=(stock_symbol)
      symbols_on_read = @stock_symbols.dup
      @stock_symbols ||= []
      @stock_symbols << stock_symbol unless @stock_symbols.include?(stock_symbol)
      run_observers if symbols_on_read != @stock_symbols
    end
    
    def yahoo_url_parameters
      return [] if !@yahoo_url_parameters || @yahoo_url_parameters.empty?
      @yahoo_url_parameters.map(&:id2name).sort.map(&:to_sym)
    end
    
    def yahoo_url_parameters=(yahoo_url_parameter)
      params_on_read = @yahoo_url_parameters.dup
      unless allowed_parameters.include?(yahoo_url_parameter)
        raise QuoteError, "Interface parameter #{yahoo_url_parameter} is not a valid parameter."
      end
      @yahoo_url_parameters ||= []
      @yahoo_url_parameters << yahoo_url_parameter unless @yahoo_url_parameters.include?(yahoo_url_parameter)
      run_observers if params_on_read != @yahoo_url_parameters
    end
    
    # Generate full url to be sent to yahoo
    def uri
      @all_stock_symbols = stock_symbols.join('+')
      invalid_params = yahoo_url_parameters-allowed_parameters
      unless invalid_params.length.zero?
        raise QuoteError, "The parameters '#{invalid_params.join(', ')}' are not valid. Please check using YahooStock::Interface::Quote#allowed_parameters or YahooStock::Quote#valid_parameters" 
      end
      @parameter_values  = yahoo_url_parameters.collect {|v| parameters[v]}.join('')
      if @all_stock_symbols.empty?
        raise QuoteError, "You must add atleast one stock symbol to get stock data" 
      end
      if @parameter_values.empty?
        raise QuoteError, "You must add atleast one parameter to get stock data" 
      end
      @uri_parameters = {:s => @all_stock_symbols, :f => @parameter_values}
      super()
    end
    
    # Read the result using get method in super class
    def get
      uri
      super()
    end
    
    # TODO MOVE TO THE HASH CLASS
    # Returns results for the stock symbols as a hash.
    # The hash keys are the stock symbols and the values are a hash of the keys and 
    # values asked for that stock.
    def results
      stock = {}
      values.each_with_index do |values, index|
        parsed_values = values.split(',')
        stock[stock_symbols[index]] ||= {}
        parsed_values.each_with_index do |value, i|
          stock[stock_symbols[index]][yahoo_url_parameters[i]] = value
        end
      end
      stock
    end
    
    # Add stock symbols to the url.
    def add_symbols(*symbols)
      symbols.each {|symbol| self.stock_symbols = symbol }
    end
    
    # Remove stock symbols from the url.
    def remove_symbols(*symbols)
      symbols.each do |symbol|
        unless stock_symbols.include?(symbol)
          raise QuoteError, "Cannot remove stock symbol #{symbol} as it is currently not present."
        end
        if stock_symbols.length == 1
          raise QuoteError, "Symbol #{symbol} is the last symbol. Please add another symbol before removing this."
        end
        stock_symbols.reject!{|stock_sym| stock_sym == symbol}
        run_observers
      end
    end
    
    # Add parameters to the url.
    def add_parameters(*parameters)
      parameters.each {|parameter| self.yahoo_url_parameters = parameter }
    end
    
    # Remove parameters from the url.
    def remove_parameters(*parameters)
      parameters.each do |parameter|
        unless yahoo_url_parameters.include?(parameter)
          raise QuoteError, "Parameter #{parameter} is not present in current list"
        end
        if yahoo_url_parameters.length == 1
          raise QuoteError, "Parameter #{parameter} is the last parameter. Please add another parameter before removing this."     
        end
        @yahoo_url_parameters.reject!{|parameter_key| parameter_key == parameter}
        run_observers
      end
    end
    
    # Returns an array of parameters that can be passed to yahoo.
    def allowed_parameters
      parameters.keys
    end
    
    # Add standard parameters
    def add_standard_params
      add_grouped_parameters(STD_PARAMETERS.keys)
    end
    
    # Add extended parameters
    def add_extended_params
      add_grouped_parameters(EXTENDED_PARAMETERS.keys)
    end
    
    # Add realtime parameters
    def add_realtime_params
      add_grouped_parameters(REALTIME_PARAMETERS.keys)
    end
    
    # Clear all existing parameters from the current instance.
    def clear_parameters
      @yahoo_url_parameters.clear
      run_observers
    end
    
    # Clear all existing symbols from the current instance.
    def clear_symbols
      stock_symbols.clear
      run_observers
    end
    
    private
    
    def add_grouped_parameters(parameter_group)
      return if (parameter_group - yahoo_url_parameters).empty?
      clear_parameters
      parameter_group.each { |parameter| add_parameters(parameter) }
    end
    
    def run_observers
      changed
      notify_observers
    end
    
    def parameters
      STD_PARAMETERS.merge(EXTENDED_PARAMETERS).merge(REALTIME_PARAMETERS)
    end
    
  end
end
