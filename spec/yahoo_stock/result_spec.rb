require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe YahooStock::Result do
  before(:each) do
    @string_result = 'some string result'
    @result = YahooStock::Result.new(@string_result)
  end
  
  describe "output" do
    it "should return the string" do
      @result.output.should eql(@string_result)
    end
    
    it "should not call the output method if the parameter passed is string" do
      @string_result.should_receive(:output).never
      @result.output
    end
    
    it "should call the output method if the parameter passed is not string" do
      other_result_obj = YahooStock::Result::ArrayFormat.new(@string_result)
      other_result_obj.should_receive(:output)
      result = YahooStock::Result.new(other_result_obj)
      result.output
    end
  end
  
  describe "store" do
    it "should open a file to append the output" do
      File.should_receive(:open).with('filename', 'a')
      @result.store('filename')
    end
  end
end