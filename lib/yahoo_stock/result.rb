module YahooStock
  class Result

    def initialize(context)
      @context = context
    end
    
    def output
      return @context if @context.is_a?(String)
      @context.output
    end
    
    def store(filename)
      File.open(filename, 'a') do |f|
        f.write(output)
        f.write("\n")
      end
    end

  end
end