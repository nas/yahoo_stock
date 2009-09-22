module YahooStock
  class History < Base
    
    class HistoryError < RuntimeError; end
    
    def initialize(options)
      unless options.is_a?(Hash)
        raise HistoryError, 'A hash of start_date, end_date and stock_symbol is expected as parameters'
      end
      @interface = YahooStock::Interface::History.new(options)
    end
    
    # NEED TO MOVE THIS METHOD TO HASH_FORMAT CLASS
    # Return an array of hashes with latest date first
    # Each array element contains a hash of date, volume traded, opening, closing, high and low prices
    def results
      values = @interface.get.split(/\n/)
      headers, daily_data = values.partition{|h| h==values[0]}
      headings = headers.first.split(',')
      data = []
      daily_data.each do |datum|
        daily_values = {}
        datum.split(',').each_with_index do |item, i|
          daily_values[headings[i]] = item
        end
        data << daily_values
      end
      data
    end
    
  end
end
