=begin

== DESCRIPTION:

Provides the stock related current data.

== USAGE:

* Initialize quote object

quote = YahooStock::Quote.new(:stock_symbols => ['YHOO', 'GOOG'])

* To view the valid parameters that can be passed

quote.valid_parameters

* To view the current parameters used

quote.current_parameters

* To view the current stock symbols used

quote.current_symbols

* To add more stocks to the list

quote.add_symbols('MSFT', 'AAPL')

* To remove stocks from list

quote.remove_symbols('MSFT', 'AAPL')

* To get data for all stocks

quote.get

=end

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
    
    def get
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
