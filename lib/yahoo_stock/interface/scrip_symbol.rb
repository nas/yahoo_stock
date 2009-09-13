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
    
    def uri
      @uri_parameters = {:s => @company}
      super()  
    end

    def get
      uri
      super()
    end
    
  end
  
end