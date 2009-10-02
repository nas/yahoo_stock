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
      @find_values.sub(/Date.*\s/,'') if @find_values
    end
    
    def values_with_header
      @interface.values
    end
    
    def data_attributes
      return unless values_with_header
      data_attributes = /Date.*\s/.match(values_with_header)
      unless data_attributes.nil?
        @data_attributes = data_attributes[0].sub(/\s*$/,'').split(',')
        @data_attributes.map &:strip
      end
    end
    
  end
end
