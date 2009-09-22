module YahooStock
   # ==DESCRIPTION:
   # 
   # Class to generate the right url and interface with yahoo to get Scrip / Stock Symbols
   #
  class Interface::ScripSymbol < Interface

    class ScripSymbolError < RuntimeError ; end
    
    # Scrapes the resulting page and gets data in between two points
    def initialize(company)
      @base_url = BASE_URLS[:scrip_symbol]
      @company = company.gsub(/\s/,'+')
      @before_element = 'yfi_sym_results'
      @after_element = 'yfi_fp_left_bottom'
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
    
    def values
      @values ||= get_values
    end
    
    private
    
    # returns only the text among two points
    def text_range
      body = get.gsub!(/\s*/,'')
      pattern = /#{@before_element}.*#{@after_element}/
      results = pattern.match(body)
      return results[0] if results
    end
    
    # Returns all possible values in a single string
    def get_values
      data = []
      rows = text_range.to_s.split(/\<\/tr>/)
      rows.each_with_index do |row, row_i|
        cells = row.split(/\<\/td>/)
        row_data = []
        cells.each_with_index do |cell, cell_i|
          datum = cell.sub('</a>','').gsub(/\<.*\>/,'')
          row_data << datum if !datum.nil? || datum.empty?
          row_data.reject!{|rd| rd.empty?}
        end
        data << row_data.join(', ') if row_data.length > 1 
      end
      data.join("\r\n")
    end
    
  end
  
end