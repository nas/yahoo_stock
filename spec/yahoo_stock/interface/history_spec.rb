require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe YahooStock::Interface::History do
  
  describe ".new" do
    
    it "should raise error when no parameter is passed during object initialization" do
      lambda { YahooStock::Interface::History.new 
        }.should raise_error(ArgumentError)
    end
    
    it "should raise an error if stock symbol key is not present in parameter hash" do
      lambda { YahooStock::Interface::History.new(:start_date => Date.today-7) 
        }.should raise_error(YahooStock::Interface::History::HistoryError, ':stock_symbol key is not present in the parameter hash')
    end
    
    it "should raise error when stock_symbol value in hash is nil" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => nil)
         }.should raise_error(YahooStock::Interface::History::HistoryError, ':stock_symbol value cannot be nil or blank')
    end
    
    it "should raise error when stock_symbol value in hash is blank" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => '')
         }.should raise_error(YahooStock::Interface::History::HistoryError, ':stock_symbol value cannot be nil or blank')
    end
    
    it "should raise error when start date key is not present in parameter hash" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd') }.should raise_error(YahooStock::Interface::History::HistoryError, ':start_date key is not present in the parameter hash')
    end
    
    it "should raise error when start_date value is nil" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', :start_date => nil) }.should raise_error(YahooStock::Interface::History::HistoryError, ':start_date value cannot be blank')
    end
    
    it "should raise error when start_date value is blank" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', :start_date => '') }.should raise_error(YahooStock::Interface::History::HistoryError, ':start_date value cannot be blank')
    end
    
    it "should raise error when start date value is not of type date" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', :start_date => '23/3/2009') }.should raise_error(YahooStock::Interface::History::HistoryError, 'Start date must be of type Date')
    end
    
    it "should raise error when end date key is not present in parameter hash" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', :start_date => Date.today-1) }.should raise_error(YahooStock::Interface::History::HistoryError, ':end_date key is not present in the parameter hash')
    end
    
    it "should raise error when end_date value is nil" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                       :start_date => Date.today-1, 
                                       :end_date => nil) }.should raise_error(YahooStock::Interface::History::HistoryError, ':end_date value cannot be blank')
    end
    
    it "should raise error when end_date value is blank" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                       :start_date => Date.today-1, 
                                       :end_date => '') }.should raise_error(YahooStock::Interface::History::HistoryError, ':end_date value cannot be blank')
    end
    
    it "should raise error when end date value is not of type date" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                       :start_date => Date.today-1, 
                                       :end_date => 'sds') }.should raise_error(YahooStock::Interface::History::HistoryError, 'End date must be of type Date')
    end
    
    it "should raise error when start date is not less than today" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                       :start_date => Date.today, 
                                       :end_date => Date.today) 
        }.should raise_error(YahooStock::Interface::History::HistoryError, 'Start date must be in the past')
    end
    
    it "should raise error when start date is greater than end date" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                       :start_date => Date.today-7, 
                                       :end_date => Date.today-8) 
        }.should raise_error(YahooStock::Interface::History::HistoryError, 'End date must be greater than the start date')
    end
    
    it "should not raise error when start date is in the past, end date is greater than start date and all relevant keys are present with right type" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                       :start_date => Date.today-7, 
                                       :end_date => Date.today-1) 
        }.should_not raise_error
      
    end
    
    it "should by default set interval to daily if no value provided for it" do
      @history = YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                       :start_date => Date.today-7, 
                                       :end_date => Date.today-1)
      @history.interval.should eql(:daily)
    end
    
    it "should raise invalid keys error when an invalid key is passed in the parameter" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                       :start_date => Date.today-7, 
                                       :end_date => Date.today-1, :boom => 1) }.should raise_error(YahooStock::Interface::History::HistoryError, "An invalid key 'boom' is passed in the parameters. Allowed keys are stock_symbol, start_date, end_date, interval")
    end
    
    it "should raise error when interval is neither :daily, :weekly or :monthly" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                       :start_date => Date.today-7, 
                                       :end_date => Date.today-1,
                                       :interval => :yearly)
                                        }.should raise_error(YahooStock::Interface::History::HistoryError, "Allowed values for interval are daily, weekly, monthly")
      
    end
    
    it "should not raise error when interval is :daily" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                       :start_date => Date.today-7, 
                                       :end_date => Date.today-1,
                                       :interval => :daily)
                                        }.should_not raise_error
      
    end
  end
  
  describe "setters" do
    before(:each) do
      @history = YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                         :start_date => Date.today-7, 
                                         :end_date => Date.today-1)
    end
    
    it "should raise error when stock symbol is being set to nil" do
      lambda { @history.stock_symbol = nil 
        }.should raise_error(YahooStock::Interface::History::HistoryError, ':stock_symbol value cannot be nil or blank')
    end
    
    it "should raise error when stock symbol is being set to an empty string" do
      lambda { @history.stock_symbol = '' 
        }.should raise_error(YahooStock::Interface::History::HistoryError, ':stock_symbol value cannot be nil or blank')
    end
    
    it "should set the new stock symbol value when it is valid" do
      @history.stock_symbol = 'new_val'
      @history.stock_symbol.should eql('new_val') 
    end
    
    it "should raise error when start date type is not a date" do
      lambda { @history.start_date = '21/3/2009' 
        }.should raise_error(YahooStock::Interface::History::HistoryError, 'Start date must be of type Date')
    end
    
    it "should raise error when start date is not in the past" do
      lambda { @history.start_date = Date.today
        }.should raise_error(YahooStock::Interface::History::HistoryError, 'Start date must be in the past')
    end
    
    it "should set the start date when start date is valid" do
      s_date = Date.today-1
      @history.start_date = s_date
      @history.start_date.should eql(s_date)
    end
    
    it "should raise error when end date type is not a date" do
      lambda { @history.end_date = '21/3/2009' 
        }.should raise_error(YahooStock::Interface::History::HistoryError, 'End date must be of type Date')
    end
    
    it "should raise error when end date type is not in the past" do
      lambda { @history.end_date = Date.today
        }.should raise_error(YahooStock::Interface::History::HistoryError, 'End date must be in the past')
    end
    
    it "should raise error when end date type is not in the past" do
      e_date = Date.today-1
      @history.end_date = e_date
      @history.end_date.should eql(e_date)
    end
    
    it "should raise error when settin interval other than :daily, :monthly or :weekly" do
      lambda { @history.interval = :yearly }.should raise_error(YahooStock::Interface::History::HistoryError)
    end
    
    it "should set the interval" do
      @history.interval = :daily
      @history.interval.should eql(:daily)
    end
    
  end
end