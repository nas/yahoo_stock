module YahooStock
  
  # == DESCRIPTION:
  #   Parse results to show in an array form
  # 
  # == USAGE
  #   YahooStock::Result::ArrayFormat.output("data as string")
  # 
  # Mostly will be used as a separate strategy for formatting results
  module Result
    class ArrayFormat
      
      def initialize(data)
        @data = data
      end
      
      def output
        val = @data.gsub(/\"/,'').split(/\r\n/)
        new_val = []
        val.each {|v| new_val << v.split(',')}
        return new_val
      end
      
      def self.output(data)
        format = self.new(data)
        format.output
      end
      
    end
  end
end