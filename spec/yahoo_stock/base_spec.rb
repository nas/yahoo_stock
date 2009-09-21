require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe YahooStock::Base do
  
  describe "find" do
    before(:each) do
      @interface = stub!('Base')
      @base = YahooStock::Base.new(@interface)
    end
    
    it "should get the values from interface" do
      @interface.should_receive(:values)
      @base.find
    end
  end
  
  describe "format" do
    before(:each) do
      @interface = stub!('Base')
      @base = YahooStock::Base.new(@interface)
    end
    
    it "should return thr results using find" do
      @base.should_receive(:find)
      @base.format
    end
    
    it "should yield the block if a block is given" do
      @base.format{"Block to pass, probably, a class with format output method"
        }.should eql('Block to pass, probably, a class with format output method')
    end
    
    it "should use the ArrayFormat class for results when :to_array is passed to the format param" do
      @base.stub!(:find)
      YahooStock::Result::ArrayFormat.should_receive(:output)
      @base.format(:to_array)
    end
   
  end
end