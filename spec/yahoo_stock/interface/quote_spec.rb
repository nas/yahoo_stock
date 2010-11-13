require File.dirname(__FILE__) + '/../../spec_helper'

describe YahooStock::Interface::Quote::Quote do
  
  before(:each) do
    @interface = YahooStock::Interface::Quote.new(:stock_symbols => ['sym1'], :read_parameters => [:param1])
    @allowed_parameters = [:param1, :param2, :param3, :zxy, :xyz, :abc, :def]
  end
  
  describe ".new" do
    
    it "should add new parameters after current parametr and sort the url parameters" do
      @interface.stub!(:allowed_parameters).and_return(@allowed_parameters)
      @interface.add_parameters :zxy, :xyz
      @interface.yahoo_url_parameters.should eql([:param1, :xyz, :zxy])
    end
    
    it "should sort the url parameters" do
      @interface.stub!(:allowed_parameters).and_return(@allowed_parameters)
      @interface.add_parameters :def, :abc
      @interface.yahoo_url_parameters.should eql([:abc, :def, :param1])
    end
    
    it "should raise InterfaceError when stock params hash is nil" do
      lambda { YahooStock::Interface::Quote.new(nil)
       }.should raise_error(YahooStock::Interface::Quote::QuoteError, 'You must pass a hash of stock symbols and the data you would like to see')
    end
    
    it "should raise ArgumentError when no parameter is passed" do
      lambda { YahooStock::Interface::Quote.new }.should raise_error(ArgumentError)  
    end
    
    it "should raise InterfaceError when stock symbols hash is nil" do
      lambda { YahooStock::Interface::Quote.new(:stock_symbols => nil) }.should raise_error(YahooStock::Interface::Quote::QuoteError, 'No stocks passed')
    end
    
    it "should raise InterfaceError when stock symbols parameter hash is an array of zero elements" do
      lambda { YahooStock::Interface::Quote.new(:stock_symbols => []) }.should raise_error(YahooStock::Interface::Quote::QuoteError, 'No stocks passed')
    end
    
    it "should raise InterfaceError when read parameters hash is nil" do
      lambda { YahooStock::Interface::Quote.new(:stock_symbols => 'sym', :read_parameters => nil) }.should raise_error(YahooStock::Interface::Quote::QuoteError,'Read parameters are not provided')
    end
    
    it "should raise InterfaceError when read parameters hash is a zero element array" do
      lambda { YahooStock::Interface::Quote.new(:stock_symbols => 'sym', :read_parameters => []) }.should raise_error(YahooStock::Interface::Quote::QuoteError,'Read parameters are not provided')
    end
    
    it "should assign appropriate values to the stock symbols accessor" do
      interface = YahooStock::Interface::Quote.new(:stock_symbols => ['sym'], :read_parameters => [:param1])
      interface.stock_symbols.should eql(['sym'])
    end
    
    it "should assign appropriate values to the yahoo url parameters accessor" do
      interface = YahooStock::Interface::Quote.new(:stock_symbols => ['sym'], :read_parameters => [:param1])
      interface.yahoo_url_parameters.should eql([:param1])
    end
    
    it "should have the base url" do
      interface = YahooStock::Interface::Quote.new(:stock_symbols => ['sym'], :read_parameters => [:param1])
      interface.base_url = 'http://download.finance.yahoo.com/d/quotes.csv'
    end
    
    it "should add the self as an observer to reset the values if any symbol or parameter is modified" do
      interface = YahooStock::Interface::Quote.new(:stock_symbols => ['sym'], :read_parameters => [:param1])
      interface.count_observers.should eql(1)
    end
    
    it "should not have zero observer" do
      interface = YahooStock::Interface::Quote.new(:stock_symbols => ['sym'], :read_parameters => [:param1])
      interface.count_observers.should_not eql(0)
    end
  end
  
  describe "scrip_symbols=" do
    
    it "should add the new symbol to the existing stock symbol array" do
      @interface.stock_symbols = 'sym2'
      @interface.stock_symbols.should include('sym2','sym1')
    end
    
    it "should not add duplicate symbols more than once" do
      @interface.stock_symbols = 'sym2'
      @interface.stock_symbols = 'sym2'
      @interface.stock_symbols.size.should eql(2)
    end
    
    it "should not run observers if symbols havent change" do
      @interface.stock_symbols = 'sym1'
      @interface.should_not_receive(:run_observers)
    end
    
    it "should run observers if stock symbols have changed" do
      @interface.stock_symbols.should eql(['sym1'])
      @interface.should_receive(:run_observers)
      @interface.stock_symbols = 'sym2'
      @interface.stock_symbols.should include('sym2','sym1')
    end
  end
  
  describe "yahoo_url_parameters=" do
    before(:each) do
      @interface.stub!(:allowed_parameters).and_return(@allowed_parameters)
    end
    it "should raise error when an invalid parameter is passed" do
      lambda { 
        @interface.yahoo_url_parameters = :random_param 
        }.should raise_error(YahooStock::Interface::Quote::QuoteError, "Interface parameter random_param is not a valid parameter.")
    end
    
    it "should add the new param to the existing params array" do
      @interface.yahoo_url_parameters = :param2
      @interface.yahoo_url_parameters.should include(:param1, :param2)
    end
    
    it "should not add duplicate params more than once" do
      @interface.yahoo_url_parameters = :param1
      @interface.yahoo_url_parameters = :param1
      @interface.yahoo_url_parameters.size.should eql(1)
    end
    
    it "should not run observers if parameters havent change" do
      @interface.yahoo_url_parameters = :param1
      @interface.should_not_receive(:run_observers)
    end
    
    it "should run observers if stock symbols have changed" do
      @interface.yahoo_url_parameters.should eql([:param1])
      @interface.should_receive(:run_observers)
      @interface.yahoo_url_parameters = :param2
      @interface.yahoo_url_parameters.should include(:param1, :param2)
    end
    
  end
  
  describe "uri" do
    before(:each) do
      @interface.stub!(:yahoo_url_parameters).and_return([:param1])
      @interface.stub!(:parameters).and_return({:param1 => 's', :param2 => 'w', :param3 => 't'})
    end
    
    it "should raise InterfaceError if the passed parameter is not present in the parameter list" do
      interface = YahooStock::Interface::Quote.new(:stock_symbols => ['sym'], :read_parameters => [:param4, :param5])
      lambda { interface.uri }.should raise_error(YahooStock::Interface::Quote::QuoteError, "The parameters 'param4, param5' are not valid. Please check using YahooStock::Interface::Quote#allowed_parameters or YahooStock::Quote#valid_parameters")
    end
    
    it "should not raise any error if parameters passed are correct" do
      lambda { @interface.uri }.should_not raise_error
    end
    
    it "should raise error if stock symbols accessor is cleared and empty" do
      @interface.stock_symbols.clear
      lambda { @interface.uri }.should raise_error(YahooStock::Interface::Quote::QuoteError, "You must add atleast one stock symbol to get stock data")
    end
    
    it "should raise error if url parameters are cleared and empty" do
      @interface.yahoo_url_parameters.clear
      lambda { @interface.uri }.should raise_error(YahooStock::Interface::Quote::QuoteError, "You must add atleast one parameter to get stock data")
    end
    
    it "should create the uri with base url" do
      @interface.uri.should =~ /http:\/\/download.finance.yahoo.com\/d\/quotes.csv?/
    end
    
    it "should create the uri with stock symbol parameter" do
      @interface.uri.should =~ /s=sym1/
    end
    
    it "should create the uri with parameter code" do
      @interface.uri.should =~ /f=s/
    end
    
    it "should have an & to join symbols and data parameter" do
      @interface.uri.should =~ /&/
    end
    
    it "should create the uri with 3 symbols" do
      @interface.stub!(:stock_symbols).and_return(['sym1','sym2', 'sym3'])
      @interface.uri.should  =~ /s=sym1\+sym2\+sym3/
    end
    
    it "should create the uri with 3 parameters" do
      @interface.stub!(:yahoo_url_parameters).and_return([:param1,:param2, :param3])
      @interface.uri.should  =~ /f=swt/
    end
    
  end
  
  describe "get" do
    before(:each) do
      @response = stub('HTTP Response')
      @response.stub!(:code).and_return('200')
      @response.stub!(:body)
      URI.stub!(:parse)
      Net::HTTP.stub!(:get_response).and_return(@response)
      @interface.stub!(:uri)
    end
    
    it "should use uri to get the content" do
      @interface.should_receive(:uri).at_least(2)
      @interface.get
    end
    
    it "should get response for the uri" do
      Net::HTTP.should_receive(:get_response).and_return(@response)
      @interface.get
    end
    
    it "should parse the uri" do
      URI.should_receive(:parse)
      @interface.get
    end
    
    it "should check the response code" do
      @response.should_receive(:code)
      @interface.get
    end
    
    it "should get the body of the response if returned code is 200, ie success" do
      @response.stub!(:code).and_return('200')
      @response.should_receive(:body)
      @interface.get
    end
    
  end
  
  describe "remove_parameters" do
    
    it "should remove the parameters if they are present" do
      params = [:test1, :test2, :test3]
      @interface = YahooStock::Interface::Quote.new(:stock_symbols => ['sym1'], :read_parameters => params)
      @interface.remove_parameters(:test1, :test2)
      @interface.yahoo_url_parameters.should eql([:test3])
    end
    
    it "should raise an error when removing a parameter that is not present" do
      lambda { @interface.remove_parameters(:test1) }.should raise_error(YahooStock::Interface::Quote::QuoteError, "Parameter test1 is not present in current list")
    end
  end
  
  describe "add_parameters" do
    
    it "should raise an error when the parameter is not a valid parameter" do
      lambda { @interface.add_parameters('test1') }.should raise_error(YahooStock::Interface::Quote::QuoteError, "Interface parameter test1 is not a valid parameter.")
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
      lambda { @interface.remove_symbols('test1') }.should raise_error(YahooStock::Interface::Quote::QuoteError, "Cannot remove stock symbol test1 as it is currently not present.")
    end
  end
  
  describe "add_symbols" do
    
    it "should add the symbol" do
      symbols = ['test1', 'test2', 'test3']
      @interface.stub!(:stock_symbols).and_return(symbols)
      @interface.add_symbols('test1', 'test2')
      @interface.stock_symbols.should include('test1', 'test2')
    end
    
    it "should not add the symbol more than once in the symbol list and silently ignore the duplicate ones" do
      @interface.add_symbols('test1', 'test2')
      @interface.stock_symbols.should include('test1', 'test2')
      @interface.stock_symbols.size.should eql(3)
      @interface.add_symbols('test1', 'test2')
      @interface.stock_symbols.should include('test1', 'test2')
      @interface.stock_symbols.size.should eql(3)
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
      YahooStock::Interface::Quote::STD_PARAMETERS.should_receive(:keys).and_return([])
      @interface.add_standard_params
    end
    
    it "should add each parameter" do
      keys = [:a_key, :b_key]
      YahooStock::Interface::Quote::STD_PARAMETERS.stub!(:keys).and_return(keys)
      @interface.should_receive(:add_parameters).with(:a_key)
      @interface.should_receive(:add_parameters).with(:b_key)
      @interface.add_standard_params
    end
    
    it "should add grouped parameters" do
      @interface.should_receive(:add_grouped_parameters)
      @interface.add_extended_params
    end
   
  end
  
  describe "add_extended_params" do
    
    it "should get the keys for extended parameters" do
      YahooStock::Interface::Quote::EXTENDED_PARAMETERS.should_receive(:keys).and_return([])
      @interface.add_extended_params
    end
    
    it "should add each parameter" do
      keys = [:a_key, :b_key]
      YahooStock::Interface::Quote::EXTENDED_PARAMETERS.stub!(:keys).and_return(keys)
      @interface.should_receive(:add_parameters).with(:a_key)
      @interface.should_receive(:add_parameters).with(:b_key)
      @interface.add_extended_params
    end
    
    it "should add grouped parameters" do
      @interface.should_receive(:add_grouped_parameters)
      @interface.add_extended_params
    end
   
  end
  
  describe "add_realtime_params" do
    
    it "should get the keys for realtime parameters" do
      YahooStock::Interface::Quote::REALTIME_PARAMETERS.should_receive(:keys).and_return([])
      @interface.add_realtime_params
    end
    
    it "should add each parameter" do
      keys = [:a_key, :b_key]
      YahooStock::Interface::Quote::REALTIME_PARAMETERS.stub!(:keys).and_return(keys)
      @interface.should_receive(:add_parameters).with(:a_key)
      @interface.should_receive(:add_parameters).with(:b_key)
      @interface.add_realtime_params
    end
    
    it "should add grouped parameters" do
      @interface.should_receive(:add_grouped_parameters)
      @interface.add_extended_params
    end
   
  end
  
  describe "clear_symbols" do
    it "should get all stock symbols" do
      @interface.should_receive(:stock_symbols).and_return([])
      @interface.clear_symbols
    end

    it "should clear all stock symbols" do
      sym = []
      @interface.stub!(:stock_symbols).and_return(sym)
      sym.should_receive(:clear)
      @interface.clear_symbols
    end

    it "should run the observers" do
      @interface.should_receive(:run_observers)
      @interface.clear_symbols
    end
  end

  describe "clear_parameters" do
    
    it "should clear all yahoo url parameters" do
      @interface.yahoo_url_parameters.should_not eql([])
      @interface.clear_parameters
      @interface.yahoo_url_parameters.should eql([])
    end
    
    it "should run the observers" do
      @interface.should_receive(:run_observers)
      @interface.clear_parameters
    end
  end
  
end
