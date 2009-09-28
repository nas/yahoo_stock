module YahooStock
  # == DESCRIPTION:
  # 
  # This class provides the ability to find out the stock /scrip symbols for a company used in stock exchanges.
  # 
  # It uses Yahoo http://finance.yahoo.com/lookup page to find, screen scrape / parse the returned results.
  # 
  # == USAGE:
  #  
  # * If you want to use the symbols in your existing code then:
  # 
  #     symbol = YahooStock::ScripSymbol.new('company name')
  # 
  #     symbol.find #will return a string
  # 
  #     symbol.results :to_array, #will return an array of values instead of a string
  # 
  # will give you an array of arrays where each outer array is the different option for the company name
  # you provided and the inner array includes stock symbol, full company name, stock price, exchange symbol
  # so that you can decide easily what symbol you can use.
  # 
  # * If you just want to print the results on your console screen
  # 
  #     YahooStock::ScripSymbol.print_options('company name')
  # 
  # * If you just want to store the results in file to use it later
  # 
  # You can pass in any number of companies in the parameter
  # 
  #     YahooStock::ScripSymbol.save_options_to_file('path/to/filename','company1', 'company2')
  # 
  class ScripSymbol < Base
    # Initialize with the name of the company as parameter for which stock symbol is needed
    # 
    #     symbol = YahooStock::ScripSymbol.new('company name')
    # 
    #     symbol.find
    
    attr_reader :company
    
    def initialize(company_name)
      @company = company_name
      @interface = YahooStock::Interface::ScripSymbol.new(@company)
    end
    
    def company=(company)
      @company = @interface.company = company
    end
    
    def data_attributes
      ['Symbol', 'Name', 'Last Trade', 'Type', 'Industry Category', 'Exchange']
    end
    
    # get stock symbols for multilple companies
    def self.results(*companies)
      res = companies.inject('') { |options, company| options + new(company).results.output + "\n" }
      YahooStock::Result.new(res)
    end

  end
end