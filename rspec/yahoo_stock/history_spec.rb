require File.dirname(__FILE__) + '/../spec_helper'

describe YahooStock::History do
  
  describe ".new" do
    
    it "should raise error when no parameter is passed during object initialization" do
      lambda { YahooStock::History.new 
        }.should raise_error(ArgumentError)
    end
    
    it "should raise error when the parameter is not a hash" do
      lambda { YahooStock::History.new(nil) 
        }.should raise_error(YahooStock::History::HistoryError, 'A hash of start_date, end_date and stock_symbol is expected as parameters')
    end
    
    it "should inititalize the history interface" do
      options = {}
      YahooStock::Interface::History.should_receive(:new).with(options)
      YahooStock::History.new({})
    end
    
  end
  
  describe "find" do
    before(:each) do
      @interface = stub('YahooStock::Interface::History')
      YahooStock::Interface::History.stub!(:new).and_return(@interface)
      @interface.stub!(:values)
      @history = YahooStock::History.new(:stock_symbol => 'a symbol', :start_date => Date.today-3, :end_date => Date.today-1)
    end
    
    it "should find values using interface" do
      @interface.should_receive(:values).and_return('data')
      @history.find
    end
    
    it "should remove the first line from the data as it is just the headings" do
      data = 'data returned'
      @interface.stub!(:values).and_return(data)
      data.should_receive(:sub).with(/Date.*\s/,'')
      @history.find
    end
  end
  
  describe "data_attributes" do
    before(:each) do
      @history = YahooStock::History.new(:stock_symbol => 'a symbol', :start_date => Date.today-3, :end_date => Date.today-1)
      @data = "Date, price, etc \n23, 34, 44\n\n222,234,2"
      @history.stub!(:values_with_header).and_return(@data)
    end
    
    it "should return nil if history values are not present" do
      @history.stub!(:values_with_header)
      @history.data_attributes.should eql(nil)
    end
    
    it "should return only header values if history values are present" do
      @history.data_attributes.should eql(["Date","price","etc"])
    end
    
  end
  
  describe "values_with_header" do
    
    it "should get values from the interface" do
      @interface = stub('YahooStock::Interface::History')
      YahooStock::Interface::History.stub!(:new).and_return(@interface)
      @history = YahooStock::History.new(:stock_symbol => 'a symbol', :start_date => Date.today-3, :end_date => Date.today-1)
      @interface.should_receive(:values)
      @history.values_with_header
    end
  end
  
end