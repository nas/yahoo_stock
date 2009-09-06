require File.dirname(__FILE__) + '/../spec_helper'

describe YahooStock::Interface do
  
  before(:each) do
    @interface = YahooStock::Interface.new(:stock_symbols => ['MSFT'], :read_parameters => [:last_trade_price_only])
  end
  
  describe "initialize" do
    
    it "should raise InterfaceError when stock params hash is nil" do
      lambda { YahooStock::Interface.new(nil)
       }.should raise_error(YahooStock::Interface::InterfaceError, 'You must pass a hash of stock symbols and the data you would like to see')
    end
    
    it "should raise ArgumentError when no parameter is passed" do
      lambda { YahooStock::Interface.new }.should raise_error(ArgumentError)  
    end
    
    it "should raise InterfaceError when stock symbols hash is nil" do
      lambda { YahooStock::Interface.new(:stock_symbols => nil) }.should raise_error(YahooStock::Interface::InterfaceError, 'No stocks passed')
    end
    
    it "should raise InterfaceError when stock symbols parameter hash is an array of zero elements" do
      lambda { YahooStock::Interface.new(:stock_symbols => []) }.should raise_error(YahooStock::Interface::InterfaceError, 'No stocks passed')
    end
    
    it "should raise InterfaceError when read parameters hash is nil" do
      lambda { YahooStock::Interface.new(:stock_symbols => 'sym', :read_parameters => nil) }.should raise_error(YahooStock::Interface::InterfaceError,'Dont know what data to get')
    end
    
    it "should raise InterfaceError when read parameters hash is a zero element array" do
      lambda { YahooStock::Interface.new(:stock_symbols => 'sym', :read_parameters => []) }.should raise_error(YahooStock::Interface::InterfaceError,'Dont know what data to get')
    end
    
    it "should assign appropriate values to the stock symbols accessor" do
      interface = YahooStock::Interface.new(:stock_symbols => ['sym'], :read_parameters => ['param1'])
      interface.stock_symbols.should eql(['sym'])
    end
    
    it "should assign appropriate values to the yahoo url parameters accessor" do
      interface = YahooStock::Interface.new(:stock_symbols => ['sym'], :read_parameters => ['param1'])
      interface.yahoo_url_parameters.should eql(['param1'])
    end
    
  end
  
  describe "full_url" do
    
    it "should raise InterfaceError if the passed parameter is not present in the parameter list" do
      interface = YahooStock::Interface.new(:stock_symbols => ['sym'], :read_parameters => [:param1, :param2])
      lambda { interface.full_url }.should raise_error(YahooStock::Interface::InterfaceError, "The parameters 'param1, param2' are not valid. Please check using YahooStock::Interface#allowed_parameters or YahooStock::Quote#valid_parameters")
    end
    
    it "should not raise any error if parameters passed are correct" do
      lambda { @interface.full_url }.should_not raise_error
    end
    
    it "should raise error if stock symbols accessor is cleared and empty" do
      @interface.stock_symbols.clear
      lambda { @interface.full_url }.should raise_error(YahooStock::Interface::InterfaceError, "You must add atleast one stock symbol to get stock data")
    end
    
    it "should raise error if url parameters are cleared and empty" do
      @interface.yahoo_url_parameters.clear
      lambda { @interface.full_url }.should raise_error(YahooStock::Interface::InterfaceError, "You must add atleast one parameter to get stock data")
    end
    
    it "should create the full url with one symbol and one parameter" do
      @interface.full_url.should eql("http://download.finance.yahoo.com/d/quotes.csv?s=MSFT&f=l1")
    end
    
    it "should create the full url with 3 symbols and 3 parameters" do
      @interface.add_symbols 'AAP', 'GOOG'
      @interface.add_parameters :change_from_200_day_moving_average, :percent_change_from_200_day_moving_average
      @interface.full_url.should eql("http://download.finance.yahoo.com/d/quotes.csv?s=MSFT+AAP+GOOG&f=l1m5m6")
    end
    
  end
  
  describe "get_values" do
    
    it "should call the class method get of HTTP class" do
      Net::HTTP.should_receive(:get).and_return('some string')
      @interface.get_values
    end
    
    it "should parse the URI" do
      Net::HTTP.stub!(:get).and_return('some string')
      URI.should_receive(:parse)
      @interface.get_values
    end
    
    it "should generate the full url by combining the stock symbols and other parameters" do
      Net::HTTP.stub!(:get).and_return('some string')
      @interface.should_receive(:full_url).and_return('http://localhost')
      @interface.get_values
    end
    
  end
  
  describe "remove_parameters" do
    
    it "should remove the parameters if they are present" do
      params = [:test1, :test2, :test3]
      @interface.stub!(:yahoo_url_parameters).and_return(params)
      @interface.remove_parameters(:test1, :test2)
      @interface.yahoo_url_parameters.should eql([:test3])
    end
    
    it "should raise an error when removing a parameter that is not present" do
      lambda { @interface.remove_parameters(:test1) }.should raise_error(YahooStock::Interface::InterfaceError, "Parameter test1 is not present in current list")
    end
  end
  
  describe "add_parameters" do
    
    it "should raise an error when the parameter is not a valid parameter" do
      lambda { @interface.add_parameters('test1') }.should raise_error(YahooStock::Interface::InterfaceError, "Interface parameter test1 is not a valid parameter.")
    end
    
    it "should add the parameter if its a valid parameter" do
      params = [:test1, :test2, :test3]
      @interface.stub!(:allowed_parameters).and_return(params)
      @interface.add_parameters(:test1, :test2)
      @interface.yahoo_url_parameters.should include(:test1, :test2)
    end
    
    it "should not add the parameter more than once in the parameter list and silently ignore it" do
      params = [:test1, :test2, :test3]
      @interface.stub!(:allowed_parameters).and_return(params)
      @interface.add_parameters(:test1, :test2)
      @interface.yahoo_url_parameters.should include(:test1, :test2)
      @interface.yahoo_url_parameters.size.should eql(3)
      @interface.add_parameters(:test1, :test2)
      @interface.yahoo_url_parameters.should include(:test1, :test2)
      @interface.yahoo_url_parameters.size.should eql(3)
    end
  end
  
  describe "remove_symbols" do
    
    it "should remove the symbols if they are present" do
      symbols = ['test1', 'test2', 'test3']
      @interface.stub!(:stock_symbols).and_return(symbols)
      @interface.remove_symbols('test1', 'test2')
      @interface.stock_symbols.should eql(['test3'])
    end
    
    it "should raise an error when removing a symbol that is not present" do
      lambda { @interface.remove_symbols('test1') }.should raise_error(YahooStock::Interface::InterfaceError, "Cannot remove stock symbol test1 as it is currently not present.")
    end
  end
  
  describe "add_symbols" do
    
    it "should add the symbol" do
      symbols = ['test1', 'test2', 'test3']
      @interface.stub!(:stock_symbols).and_return(symbols)
      @interface.add_symbols('test1', 'test2')
      @interface.stock_symbols.should include('test1', 'test2')
    end
    
    it "should not add the symbol more than once in the symbol list and silently ignore it" do
      symbols = ['test']
      @interface.stub!(:stock_symbols).and_return(symbols)
      @interface.add_symbols('test1', 'test2')
      @interface.stock_symbols.should include('test1', 'test2')
      @interface.stock_symbols.size.should eql(3)
      @interface.add_symbols('test1', 'test2')
      @interface.stock_symbols.should include('test1', 'test2')
      @interface.stock_symbols.size.should eql(3)
    end
  end
  
  describe "results" do
    
    before(:each) do
      symbols = ['sym1', 'sym2', 'sym3']
      @interface.stub!(:stock_symbols).and_return(symbols)
      params = [:test1, :test2, :test3]
      @interface.stub!(:yahoo_url_parameters).and_return(params)
    end
    
    it "should get all values" do
      @interface.should_receive(:get_values).and_return([])
      @interface.results
    end
    
    it "should have a hash of symbols and each parameter value" do
      @values = ["23,787,09","43,45,65", "6,56,8"]
      @interface.stub!(:get_values).and_return(@values)
      @interface.results.should include({'sym1' => {:test1 => "23", :test2 => "787", :test3 => "09"}})
      @interface.results.should include({'sym2' => {:test1 => "43", :test2 => "45", :test3 => "65"}})
      @interface.results.should include({'sym3' => {:test1 => "6", :test2 => "56", :test3 => "8"}})
    end
    
  end
   
  describe "allowed_parameters" do
    
    it "should find all parameters" do
      @interface.should_receive(:parameters).and_return({})
      @interface.allowed_parameters
    end
    
    it "should return the keys of all parameters" do
      parameter_hash = {}
      @interface.stub!(:parameters).and_return(parameter_hash)
      parameter_hash.should_receive(:keys)
      @interface.allowed_parameters
    end
    
  end
  
  describe "add_standard_params" do
    
    it "should get the keys for standard parameters" do
      YahooStock::Interface::STD_PARAMETERS.should_receive(:keys).and_return([])
      @interface.add_standard_params
    end
    
    it "should add each parameter" do
      keys = [:a_key, :b_key]
      YahooStock::Interface::STD_PARAMETERS.stub!(:keys).and_return(keys)
      @interface.should_receive(:add_parameters).with(:a_key)
      @interface.should_receive(:add_parameters).with(:b_key)
      @interface.add_standard_params
    end
   
  end
  
  describe "add_extended_params" do
    
    it "should get the keys for extended parameters" do
      YahooStock::Interface::EXTENDED_PARAMETERS.should_receive(:keys).and_return([])
      @interface.add_extended_params
    end
    
    it "should add each parameter" do
      keys = [:a_key, :b_key]
      YahooStock::Interface::EXTENDED_PARAMETERS.stub!(:keys).and_return(keys)
      @interface.should_receive(:add_parameters).with(:a_key)
      @interface.should_receive(:add_parameters).with(:b_key)
      @interface.add_extended_params
    end
   
  end
  
  describe "add_realtime_params" do
    
    it "should get the keys for realtime parameters" do
      YahooStock::Interface::REALTIME_PARAMETERS.should_receive(:keys).and_return([])
      @interface.add_realtime_params
    end
    
    it "should add each parameter" do
      keys = [:a_key, :b_key]
      YahooStock::Interface::REALTIME_PARAMETERS.stub!(:keys).and_return(keys)
      @interface.should_receive(:add_parameters).with(:a_key)
      @interface.should_receive(:add_parameters).with(:b_key)
      @interface.add_realtime_params
    end
   
  end
  
end
