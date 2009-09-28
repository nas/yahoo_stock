# YahooStock::Base class to find and output results.
module YahooStock
  
  class Base
    
    def initialize(interface)
      @interface = interface
    end
    
    # Uses the values method of the interface used to show results .
    def find
      @interface.values
    end
    
    # Method takes one parameter type or a block
    # type uses the existing format classes namespaced in Result::ClassName.output
    # e.g. * results :to_array
    #      * results {YourSpecialFormat.method_name}
    # to store
    def results(type=nil, &block)
      if block_given?
        yield
      else
        return YahooStock::Result.new(find) if !type || type.to_s.empty?
        format_type = type.to_s.sub(/^to_/,'').strip
        return YahooStock::Result.const_get("#{format_type.capitalize}Format").new(find){data_attributes}
      end
    end
    
    # Abstract method
    def data_attributes
      raise 'Abstract method called. Use the subclass data_attributes method'
    end
    
  end
  
end