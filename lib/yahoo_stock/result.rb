module YahooStock
  class Result
    def initialize(klass)
      @klass = klass
    end
    
    def output
      return @klass if @klass.is_a?(String)
      @klass.output
    end
    
    def store(filename)
      File.open(filename, 'a') do |f|
        f.write(output)
        f.write("\n")
      end
    end
  end
end