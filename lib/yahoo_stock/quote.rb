module YahooStock
  class Quote
    
    class QuoteException < RuntimeError; end
    
    # options expects a hash with two key value pairs
    # :stock_symbols => 'Array of stock symbols'
    # e.g. :stock_symbols => [:MSFT,:YHOO]
    # another :read_parameters => 'array of values'
    # e.g. :read_parameters => [:last_trade_price_only, :last_trade_date]
    # usage YahooStock::Quote.new(:stock_symbols => ['MSFT','YHOO'], :read_parameters => [:last_trade_price_only, :last_trade_date])
    def initialize(options)
      if options.nil? || !options[:stock_symbols]
        raise QuoteException, "You must provide a hash of stock symbols to fetch data"
      end
      unless options[:stock_symbols].any?
        raise QuoteException, "You must provide atleast one stock symbol to fetch data"
      end
      if !(options[:read_parameters] && options[:read_parameters].any?)
        options[:read_parameters] = [:last_trade_price_only, :last_trade_date]
      end
      options[:stock_symbols] = options[:stock_symbols].to_a unless options[:stock_symbols].kind_of?(Array)
      @interface = YahooStock::Interface.new(options)
    end
    
    def get_data
      @interface.results
    end
    
    def add_symbols(*symbols)
      symbols.each { |symbol| @interface.add_symbols(symbol) }
    end
    
    def remove_symbols(*symbols)
      symbols.each { |symbol| @interface.remove_symbols(symbol) }
    end
    
    def clear_symbols
      @interface.stock_symbols.clear
    end
    
    def current_symbols
      @interface.stock_symbols
    end
    
    def add_parameters(*parameters)
      parameters.each { |parameter| @interface.add_parameters(parameter) }
    end
    
    def remove_parameters(*parameters)
      parameters.each { |parameter| @interface.remove_parameters(parameter) }
    end
    
    def current_parameters
      sort_symbols(@interface.yahoo_url_parameters)
    end
    
    def use_all_parameters
      params = valid_parameters.each {|parameter| add_parameters(parameter)}
      sort_symbols(params)
    end
    
    def clear_parameters
      @interface.yahoo_url_parameters.clear
    end
    
    def valid_parameters
      sort_symbols(@interface.allowed_parameters)
    end
    
    private
    
    def sort_symbols(array_of_symbols)
      array_of_symbols.map(&:id2name).sort.map(&:to_sym)
    end
    
  end
end
