require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe YahooStock::Base do
  before(:each) do
    @interface = stub!('Base')
    @base = YahooStock::Base.new(@interface)
  end
  
  describe "find" do
    
    it "should get the values from interface" do
      @interface.should_receive(:values)
      @base.find
    end
  end
  
  describe "results" do
    
    it "should return the results using find" do
      @base.should_receive(:find)
      @base.results 
    end
    
    it "should yield the block if a block is given" do
      @base.results {"Block to pass, probably, a class with result output method"
        }.should eql('Block to pass, probably, a class with result output method')
    end
    
    it "should use the ArrayFormat class for results when :to_array is passed to the results  param" do
      @base.stub!(:find)
      YahooStock::Result::ArrayFormat.should_receive(:new)
      @base.results(:to_array)
    end
    
    it "should create the YahooStock::Result object when no formatting option is provided" do
      find = stub('find')
      @base.stub!(:find).and_return(find)
      YahooStock::Result.should_receive(:new).with(find)
      @base.results
    end
   
  end
  describe "data_attributes" do
    it "should raise an error if the data_attributes is called as this is an abstract method" do
      lambda { @base.data_attributes }.should raise_error(RuntimeError, 'Abstract method called. Use the subclass data_attributes method')
    end
  end
end