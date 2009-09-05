=begin

== DESCRIPTION:

This class provides the ability to find out the stock /scrip symbols for a company used in stock exchanges.

It uses Yahoo http://finance.yahoo.com/lookup page to find, screen scrape / parse the returned results.

== USAGE:
 
* If you want to use the symbols in your existing code then:

symbol = YahooStock::ScripSymbol.new('company name')

symbol.parse_results

will give you an array of arrays where each outer array is the different option for the company name

you provided and the inner array includes stock symbol, full company name, stock price, exchange symbol

so that you can decide easily what symbol you can use.

* If you just want to print the results on your console screen

YahooStock::ScripSymbol.print_options('company name')

* If you just want to store the results in file to use it later

You can pass in any number of companies in the parameter

YahooStock::ScripSymbol.save_options_to_file('path/to/filename','company1', 'company2')

=end


require 'net/http'
module YahooStock
  class ScripSymbol
  
    def initialize(company)
      company = company.gsub(/\s/,'+')
      @base_url = "http://finance.yahoo.com/lookup/all?s=#{company}"
      @before_element = 'yfi_sym_results'
      @after_element = 'yfi_fp_left_bottom'
    end
  
    def get_results
      @body ||= Net::HTTP.get(URI.parse(@base_url)).gsub!(/\s*/,'')
      pattern = /#{@before_element}.*#{@after_element}/
      results = pattern.match(@body)
      if results
        return results[0]
      end
    end
    
    # Returns an array of arrays where each outer array is the different option for the company name
    # you provided and the inner array includes stock symbol, full company name, stock price, exchange symbol
    
    def parse_results
      data = []
      rows = get_results.to_s.split(/\<\/tr>/)
      rows.each_with_index do |row, row_i|
        cells = row.split(/\<\/td>/)
        row_data = []
        cells.each_with_index do |cell, cell_i|
          datum = cell.sub('</a>','').gsub(/\<.*\>/,'')
          row_data << datum if !datum.nil? || !datum.any?
          row_data.reject!{|rd| !rd.any?}
        end
        data << row_data if row_data.length > 1 
      end
      data
    end
    
    # This is just a convenience methos to print all results on your console screen 
    # and to return nil at the end. It uses parse_results method to print symbols on the screen
    def self.print_options(*company)
      company.each do |name|
        scrip_symbol = self.new(name)
        scrip_symbol.parse_results.each {|scrip| p scrip}
      end
      nil
    end
    
    def self.save_options_to_file(file_name, *company)
      File.open(file_name, 'a') do |f|
        company.each do |name|
          scrip_symbol = self.new(name)
          scrip_symbol.parse_results.each do |scrip| 
            f.write(scrip.join(', '))
            f.puts('')
          end
        end
      end
    end
    
  end
end