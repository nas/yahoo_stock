require File.dirname(__FILE__) + '/../spec_helper'

describe YahooStock::ScripSymbol do
  
  describe "get_results" do
    before(:each) do
      @scrip_symbol = YahooStock::ScripSymbol.new('company')
      @before_element = 'yfi_sym_results'
      @after_element = 'yfi_fp_left_bottom'
    end
    
    it "should call get the results from remote url" do
      Net::HTTP.should_receive(:get).and_return('some string')
      @scrip_symbol.get_results
    end
    
    it "should parse the URI" do
      Net::HTTP.stub!(:get).and_return('some string')
      URI.should_receive(:parse)
      @scrip_symbol.get_results
    end
    
    it "should remove any special characters from the returned string using regex" do
      string = 'some string'
      Net::HTTP.stub!(:get).and_return(string)
      string.should_receive(:gsub!).with(/\s*/,'')
      @scrip_symbol.get_results
    end
    
    it "should not have any special characters in the actual returned string" do
      string = "asd#{@before_element} some string \n another line substitue \t\r remove these as well #{@after_element}"
      Net::HTTP.stub!(:get).and_return(string)
      @scrip_symbol.get_results.should eql("#{@before_element}somestringanotherlinesubstitueremovetheseaswell#{@after_element}")
    end
    
    it "should not return anything if it is not between before and after element" do
      string = "some string \n another line substitue \t\r remove these as well"
      Net::HTTP.stub!(:get).and_return(string)
      @scrip_symbol.get_results.should eql(nil)
    end
    
  end
  
  describe "parse_results" do
    
  end
  
  describe ".print_options" do
    
  end
  
  # def self.print_options(*company)
  #     company.each do |name|
  #       scrip_symbol = self.new(name)
  #       scrip_symbol.parse_results.each {|scrip| p scrip}
  #     end
  #     nil
  #   end
  
  describe ".save_options_to_file" do
    
  end
  
end
