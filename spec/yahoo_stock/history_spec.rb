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
    
    it "should raise an error if stock symbol key is not present in parameter hash" do
      lambda { YahooStock::History.new(:symbol => 'symbol') 
        }.should raise_error(YahooStock::History::HistoryError, ':stock_symbol key is not present in the parameter hash')
    end
    
    it "should raise error when stock_symbol value in hash is nil" do
      lambda { YahooStock::History.new(:stock_symbol => nil)
         }.should raise_error(YahooStock::History::HistoryError, ':stock_symbol value cannot be nil or blank')
    end
    
    it "should raise error when stock_symbol value in hash is blank" do
      lambda { YahooStock::History.new(:stock_symbol => '')
         }.should raise_error(YahooStock::History::HistoryError, ':stock_symbol value cannot be nil or blank')
    end
    
    it "should raise error when start date key is not present in parameter hash" do
      lambda { YahooStock::History.new(:stock_symbol => 'd') }.should raise_error(YahooStock::History::HistoryError, ':start_date key is not present in the parameter hash')
    end
    
    it "should raise error when start_date value is nil" do
      lambda { YahooStock::History.new(:stock_symbol => 'd', :start_date => nil) }.should raise_error(YahooStock::History::HistoryError, ':start_date value cannot be blank')
    end
    
    it "should raise error when start_date value is blank" do
      lambda { YahooStock::History.new(:stock_symbol => 'd', :start_date => '') }.should raise_error(YahooStock::History::HistoryError, ':start_date value cannot be blank')
    end
    
    it "should raise error when start date value is not of type date" do
      lambda { YahooStock::History.new(:stock_symbol => 'd', :start_date => '23/3/2009') }.should raise_error(YahooStock::History::HistoryError, 'Start date must be of type Date')
    end
    
    it "should raise error when end date key is not present in parameter hash" do
      lambda { YahooStock::History.new(:stock_symbol => 'd', :start_date => Date.today-1) }.should raise_error(YahooStock::History::HistoryError, ':end_date key is not present in the parameter hash')
    end
    
    it "should raise error when end_date value is nil" do
      lambda { YahooStock::History.new(:stock_symbol => 'd', :start_date => Date.today-1, :end_date => nil) }.should raise_error(YahooStock::History::HistoryError, ':end_date value cannot be blank')
    end
    
    it "should raise error when end_date value is blank" do
      lambda { YahooStock::History.new(:stock_symbol => 'd', :start_date => Date.today-1, :end_date => '') }.should raise_error(YahooStock::History::HistoryError, ':end_date value cannot be blank')
    end
    
    it "should raise error when end date value is not of type date" do
      lambda { YahooStock::History.new(:stock_symbol => 'd', :start_date => Date.today-1, :end_date => 'sds') }.should raise_error(YahooStock::History::HistoryError, 'End date must be of type Date')
    end
    
    it "should raise error when start date is not less than today" do
      lambda { YahooStock::History.new(:stock_symbol => 'd', :start_date => Date.today, :end_date => Date.today) 
        }.should raise_error(YahooStock::History::HistoryError, 'Start date must be in the past')
    end
    
    it "should raise error when start date is greater than end date" do
      lambda { YahooStock::History.new(:stock_symbol => 'd', :start_date => Date.today-7, :end_date => Date.today-8) 
        }.should raise_error(YahooStock::History::HistoryError, 'End date must be greater than the start date')
    end
    
    it "should not raise error when start date is in the past, end date is greater than start date and all relevant keys are present with right type" do
      lambda { YahooStock::History.new(:stock_symbol => 'd', :start_date => Date.today-7, :end_date => Date.today-1) 
        }.should_not raise_error
      
    end
  end
end