# YahooStock::Base class to find and format results.
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
    # e.g. * format :to_array
    #      * format {YourSpecialFormat.method_name}
    def format(type=nil, &block)
      if block_given?
        yield
      else
        return find if !type || type.to_s.empty?
        format_type = type.to_s.sub(/^to_/,'').strip
        return YahooStock::Result.const_get("#{format_type.capitalize}Format").output(find)
      end
    end
    
  end
  
end