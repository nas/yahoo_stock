module YahooStock
  class History < Base
    
    class HistoryError < RuntimeError; end
    
    def initialize(options)
      unless options.is_a?(Hash)
        raise HistoryError, 'A hash of start_date, end_date and stock_symbol is expected as parameters'
      end
      @interface = YahooStock::Interface::History.new(options)
    end
    
    def find
      @find_values = super()
      @find_values.sub(/Date.*\s/,'')
    end
    
    def data_attributes
      find unless @find_values
      data_attributes = /Date.*\s/.match(@find_values)
      @data_attributes = data_attributes[0].sub(/\s*$/,'').split(',')
    end
    
  end
end
