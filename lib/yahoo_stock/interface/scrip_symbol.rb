module YahooStock
   # ==DESCRIPTION:
   # 
   # Class to generate the right url and interface with yahoo to get Scrip / Stock Symbols
   #
  class Interface::ScripSymbol < Interface

    class ScripSymbolError < RuntimeError ; end
    
    attr_reader :company
    # Scrapes the resulting page and gets data in between two points
    def initialize(company)
      @base_url = BASE_URLS[:scrip_symbol]
      @company = remove_any_space(company)
      @before_element = 'yfi_sym_results'
      @after_element = 'yfi_fp_left_bottom'
      add_observer(self)
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
    
    def company=(company)
      old_company = @company
      @company = remove_any_space(company)
      old_company != @company ? changed : changed(false)
      notify_observers
    end
    
    private
    
    def remove_any_space(words)
      words.gsub(/\s/,'+')
    end
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
          datum = cell.sub('</a>','').gsub(/\<.*\>/,'').strip
          row_data << datum if !datum.nil? || datum.empty?
        end
        data << row_data.join(',') if row_data.length > 1 
      end
      data.join("\r\n")
    end
    
  end
  
end