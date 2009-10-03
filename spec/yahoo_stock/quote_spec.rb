require File.join(File.dirname(__FILE__), "/../spec_helper") 

module YahooStock
  describe Quote do 
    
    describe "initialize" do
      
      it "should raise error when no parameter is passed" do
        lambda { YahooStock::Quote.new }.should raise_error
      end
    
      it "should raise QuoteException error when parameter passed is nil" do
        lambda { YahooStock::Quote.new(nil)}.should raise_error(Quote::QuoteException, 'You must provide a hash of stock symbols to fetch data')
      end
      
      it "should raise QuoteException error when parameter passed is not a hash" do
        lambda { YahooStock::Quote.new('erred')}.should raise_error(Quote::QuoteException, 'You must provide a hash of stock symbols to fetch data')
      end
    
      it "should raise QuoteException when a hash of stock_symbols are not passed" do
        lambda { YahooStock::Quote.new(:misspelled => 'YHOO')}.should raise_error(Quote::QuoteException, 'You must provide atleast one stock symbol to fetch data')
      end
    
      it "should raise QuoteException when stock symbols hash key value is an emtpy array" do
        lambda { YahooStock::Quote.new(:stock_symbols => [])}.should raise_error(Quote::QuoteException, 'You must provide atleast one stock symbol to fetch data')
      end
    
      it "should raise QuoteException when stock symbols hash key value is an emtpy string" do
        lambda { YahooStock::Quote.new(:stock_symbols => '')}.should raise_error(Quote::QuoteException, 'You must provide atleast one stock symbol to fetch data')
      end
    
      it "should create 2 read parameter when no parameters are passed" do
        quote = YahooStock::Quote.new(:stock_symbols => 'test')
        quote.current_parameters.length.should eql(2)
      end
      
      it "should have last_trade_price_only key in the read parameters when no keys are passed" do
        quote = YahooStock::Quote.new(:stock_symbols => 'test')
        quote.current_parameters.should include(:last_trade_price_only)
      end
      
      it "should have last_trade_date key in the read parameters when no keys are passed" do
        quote = YahooStock::Quote.new(:stock_symbols => 'test')
        quote.current_parameters.should include(:last_trade_date)
      end
      
      it "should convert the symbols passed to an array when passed as a single string" do
        quote = YahooStock::Quote.new(:stock_symbols => 'test')
        quote.current_symbols.should eql(['test'])
      end
      
      it "should not keep stock symbols as a string" do
        quote = YahooStock::Quote.new(:stock_symbols => 'test')
        quote.current_symbols.should_not eql('test')
      end
      
      it "should create a new instance of the Stock Interface class" do
        YahooStock::Interface::Quote.should_receive(:new)
        YahooStock::Quote.new(:stock_symbols => 'test')
      end
      
    end
    
    describe "subject" do
      
      before(:each) do
        @interface = mock(YahooStock::Interface::Quote)
        YahooStock::Interface::Quote.stub!(:new).and_return(@interface)
        @quote = YahooStock::Quote.new(:stock_symbols => 'MSFT')
      end
      
      describe "add_symbols" do
        
        it "should add the symbol to existing symbols by calling add symbols on interface" do
          @interface.should_receive(:add_symbols)
          @quote.add_symbols('new_symbol')
        end
        
      end
      
      describe "remove_symbols" do
        
        it "should remove the symbol from existing symbols by calling remove symbols on interface" do
          @interface.should_receive(:remove_symbols)
          @quote.remove_symbols('remove_symbol')
        end
        
      end
      
      describe "clear_symbols" do
        
        it "should remove the symbol from existing symbols by clearing symbols from interface" do
          @interface.should_receive(:clear_symbols)
          @quote.clear_symbols
        end
        
      end
      
      describe "current_symbols" do
        
        it "should get all stock symbols from the interface" do
          @interface.should_receive(:stock_symbols)
          @quote.current_symbols
        end
        
      end
      
      describe "add_parameters" do
        
        it "should add the parameter to existing parameter by calling add parameters on interface" do
          @interface.should_receive(:add_parameters)
          @quote.add_parameters('param1')
        end
        
      end
      
      describe "remove_parameters" do
        
        it "should remove the parameter from existing parameters by calling remove parameters on interface" do
          @interface.should_receive(:remove_parameters)
          @quote.remove_parameters('remove_parameter')
        end
        
      end
      
      describe "valid_parameters" do
        
        it "should get the valid parameters by sending allowed parameters message to the yahoo interface" do
          @quote.stub!(:sort_symbols)
          @interface.should_receive(:allowed_parameters)
          @quote.valid_parameters
        end
        
        it "sort the parameters after fetching them" do
          @interface.stub!(:allowed_parameters)
          @quote.should_receive(:sort_symbols)
          @quote.valid_parameters
        end

      end
      
      describe "current_parameters" do
        
        it "should get all current parameters from the interface" do
          @quote.stub!(:sort_symbols)
          @interface.should_receive(:yahoo_url_parameters)
          @quote.current_parameters
        end
        
      end
      
      describe "use_all_parameters" do
        
        before(:each) do
          @quote.stub!(:sort_symbols)
          @interface.stub!(:allowed_parameters)
        end
        
        it "should get all valid parameters" do
          @quote.should_receive(:valid_parameters).and_return([])
          @quote.use_all_parameters
        end
        
        it "should sort all received current parameters" do
          @quote.stub!(:valid_parameters).and_return([])
          @quote.should_receive(:sort_symbols) 
          @quote.use_all_parameters
        end
        
        it "should add each parameter" do
          @quote.stub!(:valid_parameters).and_return([:param1, :param2])
          @quote.should_receive(:add_parameters).exactly(2).times
          @quote.use_all_parameters
        end
        
      end
      
      describe "clear_parameters" do
        
        it "should get all values for parameters from the interface" do
          @quote.stub!(:current_parameters)
          @interface.should_receive(:clear_parameters)
          @quote.clear_parameters
        end
        
        it "should get current parameters after clearing them" do
          @interface.stub!(:clear_parameters)
          @quote.should_receive(:current_parameters)
          @quote.clear_parameters
        end
        
        it "clear all parameters and show an empty array when there are no yahoo url parameters" do
          @interface.stub!(:clear_parameters)
          @interface.stub!(:yahoo_url_parameters).and_return([])
          @quote.clear_parameters.should eql([])
        end
        
      end
      
      describe "realtime" do
        
        before(:each) do
          @quote.stub!(:find)
          @interface.stub!(:add_realtime_params)
        end
        
        it "should add the realtime parameters" do
          @interface.should_receive(:add_realtime_params)
          @quote.realtime
        end
        
        it "should return self" do
          @quote.realtime.should eql(@quote)
        end

      end
      
      describe "standard" do
        
        before(:each) do
          @quote.stub!(:find)
          @interface.stub!(:add_standard_params)
        end
        
        it "should add the standard parameters" do
          @interface.should_receive(:add_standard_params)
          @quote.standard
        end
        
        it "should return self" do
          @quote.standard.should eql(@quote)
        end

      end
      
      describe "extended" do
        
        before(:each) do
          @quote.stub!(:find)
          @interface.stub!(:add_extended_params)
        end
        
        it "should add the extended parameters" do
          @interface.should_receive(:add_extended_params)
          @quote.extended
        end
        
        it "should return self" do
          @quote.extended.should eql(@quote)
        end

      end
  
    end
  end 
  
  
end