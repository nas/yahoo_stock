=begin
  Main class to interface with Yahoo
=end

require 'net/http'
require 'observer'
module YahooStock
   # ==DESCRIPTION:
   # 
   # Class to generate the right url and interface with yahoo
   #
  class Interface
    include Observable
    class InterfaceError < RuntimeError ; end

    BASE_URLS = {
      :quote        => "http://download.finance.yahoo.com/d/quotes.csv",
      :history      => "http://ichart.finance.yahoo.com/table.csv",
      :scrip_symbol => "http://finance.yahoo.com/lookup/all"
    } unless defined?(BASE_URLS)
    
    attr_accessor :base_url, :uri_parameters
    
    # Send request to the uri and get results
    def get
      begin
        response = Net::HTTP.get_response(URI.parse(uri))
      rescue => e
        raise InterfaceError, "#{e.message}\n\n#{e.backtrace}"
      end
      response.code == '200' ? response.body : response_error(response)
    end
    
    # Generates full url to connect to yahoo
    def uri
      raise InterfaceError, 'Base url is require to generate full uri.' unless @base_url
      return @base_url if @uri_parameters.nil? || @uri_parameters.empty?
      params_with_values = []
      @uri_parameters.each {|k,v| params_with_values << "#{k}=#{v}"}
      @base_url+'?'+params_with_values.join('&')
    end
    
    # Get result string
    def values
      @values ||= get
    end
    
    def update
      @values = nil
    end
    
    private 
    
    # Generate error for debugging when something goes wrong while sending
    # request to yahoo
    def response_error(response)
      trace = "Response \n\nbody : #{response.body}\n\ncode: #{response.code}\n\nmessage: #{response.message}"
      case @base_url
        when BASE_URLS[:quote]
          raise InterfaceError, "Error :: Could not get stock data \n\n#{trace}"
        when BASE_URLS[:history]
          raise InterfaceError, "Error :: Could not get historical data \n\n#{trace}"
        when BASE_URLS[:scrip_symbol]
          raise InterfaceError, "Error :: Could not get stock symbol \n\n#{trace}"
        else
          raise InterfaceError, "Error connecting to #{@base_url} \n\n#{trace}"
      end
    end
    
  end
end
