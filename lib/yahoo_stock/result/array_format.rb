module YahooStock
  
  # == DESCRIPTION:
  #   Parse results to show in an array form
  # 
  # == USAGE
  #   YahooStock::Result::ArrayFormat.output("data as string")
  # 
  # Mostly will be used as a separate strategy for formatting results
    class Result::ArrayFormat < Result
      
      def initialize(data)
        @data = data
        super(self)
      end
      
      def output
        val = @data.gsub(/\"/,'').split(/\r\n|\n/)
        new_val = []
        val.each {|v| new_val << v.split(',')}
        return new_val
      end
      
    end
  
end