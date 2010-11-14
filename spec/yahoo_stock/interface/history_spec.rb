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
    
    it "should by default set type to daily if no value provided for it" do
      @history = YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                                    :start_date => Date.today-7, 
                                                    :end_date => Date.today-1)
      @history.type.should eql(:daily)
    end
    
    it "should raise invalid keys error when an invalid key is passed in the parameter" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                                  :start_date => Date.today-7, 
                                                  :end_date => Date.today-1, :boom => 1) }.should raise_error(YahooStock::Interface::History::HistoryError, "An invalid key 'boom' is passed in the parameters. Allowed keys are stock_symbol, start_date, end_date, type")
    end
    
    it "should raise error when type is neither :daily, :weekly, :monthly or :dividend" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                                  :start_date => Date.today-7, 
                                                  :end_date => Date.today-1,
                                                  :type => :yearly)
                                        }.should raise_error(YahooStock::Interface::History::HistoryError, "Allowed values for type are daily, weekly, monthly, dividend")
      
    end
    
    it "should not raise error when type is :daily" do
      lambda { YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                                  :start_date => Date.today-7, 
                                                  :end_date => Date.today-1,
                                                  :type => :daily)
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
    
    it "should raise error when settin type other than :daily, :monthly or :weekly" do
      lambda { @history.type = :yearly }.should raise_error(YahooStock::Interface::History::HistoryError)
    end
    
    it "should set the type" do
      @history.type = :daily
      @history.type.should eql(:daily)
    end
    
    it "should set the type default to daily if not set" do
      @history.type.should eql(:daily)
    end
  end
  
  describe "uri" do
    before(:each) do
      @history = YahooStock::Interface::History.new(:stock_symbol => 'symbol', 
                                                    :start_date => Date.today-7, 
                                                    :end_date => Date.today-1)
    end
    
    it "should get the type to generate url" do
      @history.should_receive(:type)
      @history.uri
    end
    
    it "should get the day of the start date" do
      @history.start_date.should_receive(:day)
      @history.uri
    end
    
    it "should get the day of the end date" do
      @history.end_date.should_receive(:day)
      @history.uri
    end
    
    it "should get the year of the start date" do
      @history.start_date.should_receive(:year)
      @history.uri
    end
    
    it "should get the day of the end date" do
      @history.start_date.should_receive(:year)
      @history.uri
    end
    
    it "should get the month of the start and end date" do
      @history.should_receive(:sprintf).exactly(2)
      @history.uri
    end
    
    it "should have the base url" do
      @history.uri.should =~ /http:\/\/ichart.finance.yahoo.com\/table.csv?/
    end
    
    it "should have parameter 'a' with month -1 " do
      month = sprintf("%02d", @history.start_date.month-1)
      @history.uri.should =~ /a=#{month}/
    end
    
    it "should have parameter 'b' with start date day " do
      @history.uri.should =~ /b=#{@history.start_date.day}/
    end
    
    it "should have parameter 'c' with start date year " do
      @history.uri.should =~ /c=#{@history.start_date.year}/
    end
    
    it "should have parameter 'd' with end date month -1 " do
      month = sprintf("%02d", @history.end_date.month-1)
      @history.uri.should =~ /d=#{month}/
    end
    
    it "should have parameter 'e' with end date day " do
      @history.uri.should =~ /e=#{@history.end_date.day}/
    end
    
    it "should have parameter 'f' with end date year " do
      @history.uri.should =~ /c=#{@history.end_date.year}/
    end
    
    it "should have parameter 'g' with type" do
      @history.uri.should =~ /g=d/
    end
    
    it "should have the parameter 's' with stock symbol" do
      @history.uri.should =~ /s=symbol/
    end
    
  end
  
  describe "get" do
    before(:each) do
      @history = YahooStock::Interface::History.new(:stock_symbol => 'd', 
                                                    :start_date => Date.today-7, 
                                                    :end_date => Date.today-1)
      response = stub('HTTP')
      Net::HTTP.stub!(:get_response).and_return(response)
      response.stub!(:code).and_return('200')
      response.stub!(:body)
    end
    
    it "should check the stock symbol" do
      @history.should_receive(:stock_symbol).times.at_least(2).and_return('symbol')
      @history.get
    end
    
    it "should check the end date" do
      @history.should_receive(:end_date).times.at_least(1).and_return(Date.today-1)
      @history.get
    end
    
    it "should check the start date" do
      @history.should_receive(:start_date).times.at_least(1).and_return(Date.today-7)
      @history.get
    end
    
    it "should raise error if start date is not present" do
      @history.stub!(:start_date)
      lambda { @history.get }.should raise_error('Cannot send request unless all parameters, ie stock_symbol, start and end date are present')
    end
    
    it "should raise error if end date is not present" do
      @history.stub!(:end_date)
      lambda { @history.get }.should raise_error('Cannot send request unless all parameters, ie stock_symbol, start and end date are present')
    end
    
    it "should raise error if stock symbol is not present" do
      @history.stub!(:stock_symbol)
      lambda { @history.get }.should raise_error('Cannot send request unless all parameters, ie stock_symbol, start and end date are present')
    end
    
    it "should send the http request to yahoo" do
      Net::HTTP.should_receive(:get_response)
      @history.get
    end
    
    it "should parse the url" do
      URI.should_receive(:parse)
      @history.get
    end
    
  end
  
end