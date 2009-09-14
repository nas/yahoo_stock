module YahooStock
  
  # == DESCRIPTION:
  #   Parse results to show or store in different formats.
  
  class ResultParser
    
    attr_accessor :filename
    
    # Pass result as a string parameter
    def initialize(result, filename=nil)
      @result = result
      @filename = filename
    end
    
    def to_array
      @result
    end
    alias :to_a :to_array
    
    def to_hash
      
    end
    alias :to_h :to_hash
    
    def to_xml(type)
      result_file(type, 'xml')
    end
    alias :to_x :to_xml
    
    def to_yaml(type)
      result_file(type, 'yml')
    end
    alias :to_y :to_yaml
    
    def print_on_screen
      
    end
    alias :p :print_on_screen
    
    def save_to_file(type)
      result_file(type, 'txt')
    end
    alias :save :save_to_file
    
    private
    
    def result_file(type, extension)
      filename ? filename : Time.now.strftime("#{type}_%d_%m_%y_%H_%M_%S.#{extension}")
    end
    
  end
  
end