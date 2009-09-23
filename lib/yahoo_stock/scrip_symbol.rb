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
  #     symbol.format :to_array, #will return an array of values instead of a string
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
    def initialize(company)
      @interface = YahooStock::Interface::ScripSymbol.new(company)
    end
    
    # This is just a convenience method to print all results on your console screen 
    # and to return nil at the end. It uses find method to print symbols on the screen.
    def self.print_options(*companies)
      companies.each do |name|
        scrip_symbol = self.new(name)
        scrip_symbol.find.each {|scrip| p scrip}
      end
      nil
    end
    
    # Another convenience method to store all returned results into a file
    def self.save_options_to_file(file_name, *companies)
      File.open(file_name, 'a') do |f|
        companies.each do |name|
          scrip_symbol = self.new(name)
          scrip_symbol.find.each do |scrip| 
            f.write(scrip.join(', '))
            f.puts('')
          end
        end
      end
    end
    
  end
end