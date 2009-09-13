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
  
  
end