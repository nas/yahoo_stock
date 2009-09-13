require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe YahooStock::Interface::ScripSymbol do
  before(:each) do
    @interface = YahooStock::Interface::ScripSymbol.new('company_name')
  end
  describe "get" do
    before(:each) do
      @response = stub('Response')
      Net::HTTP.stub!(:get_response).and_return(@response)
      URI.stub!(:parse)
      @response.stub!(:code).and_return('200')
      @response.stub!(:body)
    end
    
    it "should find or generate the uri once in the get method and once in the get method of the super class" do
      @interface.should_receive(:uri).twice
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
      @response.should_receive(:body)
      @interface.get
    end
  end
  
  describe "uri" do
    it "should generate full url with all paramenters" do
      @interface.base_url = 'http://download.finance.yaaaaahoo.com/d/quotes.csv'
      @interface.uri.should eql('http://download.finance.yaaaaahoo.com/d/quotes.csv?s=company_name')
    end
  end
  
end