require 'rubygems'
require 'builder'

module YahooStock
  # == DESCRIPTION:
  # Convert results to xml
  # 
  # == USAGE
  # YahooStock::Result::XmlFormat.new("data as string"){[:keys => :values]}.output
  #
  # Mostly will be used as a separate strategy for formatting results  to xml
  
  class Result::XmlFormat < Result
    def initialize(data, &block)
      @hash_format = YahooStock::Result::HashFormat.new(data){yield}
      @data = @hash_format.output
      super(self)
    end
    
    def output
      builder = Builder::XmlMarkup.new(:indent=>2)
      builder.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
      builder.items do |items|
        @data.each do |data|
          builder.item do |b|
            data.each_pair do |key, value|
              next if key.nil?
              eval("b.#{key}(value)")
            end
          end
        end
      end
      builder
    end
  end
  
end