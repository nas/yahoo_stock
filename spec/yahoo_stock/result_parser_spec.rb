require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe YahooStock::ResultParser do
  before(:each) do
    @result_parser = YahooStock::ResultParser.new('result string')
  end
  
  describe "to_array" do
    
    it "should call to_array" do
      @result_parser.to_array
    end
  end
  
  describe "to_hash" do
    
    it "should call to_hash" do
      @result_parser.to_hash
    end
  end
  
  describe "to_xml" do
    
    it "should call to_xml" do
      @result_parser.to_xml('history')
    end
  end
  
  describe "to_yaml" do
    
    it "should call to_yaml" do
      @result_parser.to_yaml('history')
    end
  end
  
  describe "print_on_screen" do
    
    it "should call print on screen" do
      @result_parser.print_on_screen
    end
  end
  
  describe "save_to_file" do
    
    it "should call save_to_file" do
      @result_parser.save_to_file('history')
    end
  end
end