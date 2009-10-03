module YahooStock
  # == DESCRIPTION:
  # Convert results as an array of key value pairs
  # 
  # == USAGE
  # YahooStock::Result::HashFormat.new("data as string"){['array', 'of', 'keys']}.output
  # The number of keys in the block array must be equal to the values expected to be returned
  #
  # Mostly will be used as a separate strategy for formatting results
  class Result::HashFormat < Result
    
    def initialize(data, &block)
      @data = YahooStock::Result::ArrayFormat.new(data).output
      @keys = yield
      super(self)
    end
    
    def output
      data = []
      @data.each do |datum|
        row_values = {}
        datum.each_with_index do |item, i|
          row_values[keys[i]] = item
        end
        data << row_values
      end
      data
    end
    
    def keys
      @keys.collect{|key| key.to_s.gsub(/\s/,'_').downcase.to_sym}
    end
    
  end

  
end