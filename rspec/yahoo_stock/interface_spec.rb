require File.dirname(__FILE__) + '/../spec_helper'

describe YahooStock::Interface do
  
  before(:each) do
    @interface = YahooStock::Interface.new
    @interface.base_url = 'http://download.finance.yaaaaahoo.com/d/quotes.csv'
  end
  describe "uri" do
    it "should return base url when uri_parameters is empty" do
      @interface.uri.should eql('http://download.finance.yaaaaahoo.com/d/quotes.csv')
    end
    
    it "should raise error when base url is not present" do
      @interface.base_url = nil
      lambda { @interface.uri }.should raise_error(YahooStock::Interface::InterfaceError, 
                                                   'Base url is require to generate full uri.')
    end
    
    it "should generate full url with all paramenters" do
      @interface.uri_parameters = {:s => 'boom', :f => 'toom', :k => 'zoom'}
      @interface.uri.should =~ /http:\/\/download.finance.yaaaaahoo.com\/d\/quotes.csv?/
      @interface.uri.should =~ /s=boom/
      @interface.uri.should =~ /f=toom/
      @interface.uri.should =~ /k=zoom/
    end
  end
  
  describe "get" do
    before(:each) do
      @response = stub('HTTP Response')
      @response.stub!(:code).and_return('200')
      @response.stub!(:body)
      URI.stub!(:parse)
      Net::HTTP.stub!(:get_response).and_return(@response)
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
    
    describe "when response code is not 200" do
      before(:each) do
         @response.stub!(:code).and_return('301')
         @response.stub!(:body).and_return('something')
         @response.stub!(:message).and_return('eerrred')
      end
      
      it "should return the response error when returned code is not 200" do
        @interface.should_receive(:response_error)
        @interface.get
      end
      
      it "should not get the body of the response when returned code is not 200" do
        @interface.should_receive(:response_error)
        @response.should_not_receive(:body)
        @interface.get
      end
      
      it "should raise error when returned code is not 200" do
        @interface.base_url = YahooStock::Interface::BASE_URLS[:quote]
        lambda { @interface.get }.should raise_error
      end
    end
    
  end
  
  describe "values" do
    it "should call get to receive the values" do
      @interface.should_receive(:get)
      @interface.values
    end
    
    it "should not call get when values are already set" do
      @interface.stub!(:values).and_return('some string')
      @interface.should_not_receive(:get)
      @interface.values
    end
  end
  
  describe "update" do
    it "should set the values to nil" do
      @interface.update.should be_nil
    end
  end
  
end
