module YahooStock
   # ==DESCRIPTION:
   # 
   # Class to generate the right url and interface with yahoo to get Scrip / Stock Symbols
   #
  class Interface::ScripSymbol < Interface

    class ScripSymbolError < RuntimeError ; end
    
    def initialize(company)
      @base_url = BASE_URLS[:scrip_symbol]
      @company = company.gsub(/\s/,'+')
    end
    
    # Generate full uri with the help of uri method of the superclass
    def uri
      @uri_parameters = {:s => @company}
      super()  
    end

    # Get uri content with the help of get method of the super class
    def get
      uri
      super()
    end
    
  end
  
end