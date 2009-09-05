module YahooStock
  # == DESCRIPTION:
  # 
  # Provides the stock related current data.
  # 
  # Uses YahooStock::Interface to connect to yahoo and get relevant data.
  # 
  # == USAGE:
  # 
  # * Initialize quote object
  # 
  #     quote = YahooStock::Quote.new(:stock_symbols => ['YHOO', 'GOOG'], 
  #                                   :read_parameters => [:last_trade_price_only, :last_trade_date])
  # 
  # If read_parameters are not provided then by default the above two parameters are used.
  # 
  # * To get data for all stocks
  # 
  #     quote.get
  # 
  # * To view the valid parameters that can be passed
  # 
  #     quote.valid_parameters
  # 
  # * To view the current parameters used
  # 
  #     quote.current_parameters
  # 
  # * To view the current stock symbols used
  # 
  #     quote.current_symbols
  # 
  # * To add more stocks to the list
  # 
  #     quote.add_symbols('MSFT', 'AAPL')
  # 
  # * To remove stocks from list
  # 
  #     quote.remove_symbols('MSFT', 'AAPL')
  # 
  class Quote
    class QuoteException < RuntimeError; end
    
    # The options parameter expects a hash with two key value pairs
    # 
    # :stock_symbols => 'Array of stock symbols' or a single symbol
    # 
    # e.g. :stock_symbols => ['MSFT','YHOO'] or :stock_symbols => 'YHOO'
    # 
    # another hash :read_parameters => 'array of values'
    # 
    # e.g. :read_parameters => [:last_trade_price_only, :last_trade_date]
    def initialize(options)
      if options.nil? || !options[:stock_symbols]
        raise QuoteException, "You must provide a hash of stock symbols to fetch data"
      end
      if options[:stock_symbols].nil? || options[:stock_symbols].empty?
        raise QuoteException, "You must provide atleast one stock symbol to fetch data"
      end
      if !(options[:read_parameters] && options[:read_parameters].any?)
        options[:read_parameters] = [:last_trade_price_only, :last_trade_date]
      end
      options[:stock_symbols] = options[:stock_symbols].to_a unless options[:stock_symbols].kind_of?(Array)
      @interface = YahooStock::Interface.new(options)
    end
    
    # Returns results for the stock symbols as a hash.
    # The hash keys are the stock symbols and the values are a hash of the keys and 
    # values asked for that stock.
    def get
      @interface.results
    end
    
    # Adds more stock symbols to the existing instance.
    # One or more stock symbols can be passed as parameter.
    def add_symbols(*symbols)
      symbols.each { |symbol| @interface.add_symbols(symbol) }
    end
    
    # Removes stock symbols from the existing instance.
    # One of more stock symbols can be passed to remove.
    def remove_symbols(*symbols)
      symbols.each { |symbol| @interface.remove_symbols(symbol) }
    end
    
    # Clear all existing stock symbols from the current instance.
    def clear_symbols
      @interface.stock_symbols.clear
    end
    
    # Show all stock symbols in the current instance that will be used to get results.
    def current_symbols
      @interface.stock_symbols
    end
    
    # Adds more parameters for the stock symbols to the existing instance for getting data.
    # One or more parameters can be passed as argument.
    def add_parameters(*parameters)
      parameters.each { |parameter| @interface.add_parameters(parameter) }
    end
    
    # Removes parameters for the stock symbols to get values for from the existing instance.
    # One of more parameters can be passed to remove.
    def remove_parameters(*parameters)
      parameters.each { |parameter| @interface.remove_parameters(parameter) }
    end
    
    # Shows all parameters in the current instance that will be used to get results.
    def current_parameters
      sort_symbols(@interface.yahoo_url_parameters)
    end
    
    # Set current instance to use all parameters to fetch values for current symbols.
    def use_all_parameters
      params = valid_parameters.each {|parameter| add_parameters(parameter)}
      sort_symbols(params)
    end
    
    # Clear all existing parameters from the current instance.
    def clear_parameters
      @interface.yahoo_url_parameters.clear
    end
    
    # Returns an array of all allowed parameters that can be used.
    def valid_parameters
      sort_symbols(@interface.allowed_parameters)
    end
    
    private
    
    def sort_symbols(array_of_symbols)
      array_of_symbols.map(&:id2name).sort.map(&:to_sym)
    end
    
  end
end
