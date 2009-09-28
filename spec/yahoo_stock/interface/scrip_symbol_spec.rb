require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe YahooStock::Interface::ScripSymbol do
  before(:each) do
    @interface = YahooStock::Interface::ScripSymbol.new('company name')
  end
  
  describe ".new" do
    it "should replace any space from company name with +" do
      @interface.company.should eql('company+name')
    end
    
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
      @interface.uri.should eql('http://download.finance.yaaaaahoo.com/d/quotes.csv?s=company+name')
    end
  end
  
  describe "values" do
    before(:each) do
      @text = "<tr><td>Company Name</td><td class ='dd'>symbol</td><td class='ss'>price</td></tr>"
      @scrip_symbol = YahooStock::Interface::ScripSymbol.new('a company')
      @scrip_symbol.stub!(:text_range).and_return(@text)
    end
    
    it "should use the get values pvt method to generate the values string" do
      @scrip_symbol.should_receive(:get_values)
      @scrip_symbol.values
    end
    
    it "should not call the get values pvt method if the value is already present" do
      @scrip_symbol.stub!(:values).and_return('somthing')
      @scrip_symbol.should_not_receive(:get_values)
      @scrip_symbol.values
    end
    
    it "should return a comma separated string" do
      @scrip_symbol.values.should eql('Company Name,symbol,price')
    end
    
    it "should return a comma separated string with line break chars if more than one row is present" do
      @text += "<tr><td>Company Name</td><td class ='dd'>symbol</td><td class='ss'>price</td></tr>"
      @scrip_symbol.stub!(:text_range).and_return(@text)
      @scrip_symbol.values.should eql("Company Name,symbol,price\r\nCompany Name,symbol,price")
    end
    
    it "should remove any hyperlinks" do
      @text += "<tr><td><a href='asd'>Company Name</a></td><td class ='dd'>symbol</td><td class='ss'>price</td></tr>"
      @scrip_symbol.stub!(:text_range).and_return(@text)
      @scrip_symbol.values.should eql("Company Name,symbol,price\r\nCompany Name,symbol,price")
    end
    
    it "should not get rid of any blank values" do
       @text += "<tr><td></td><td class ='dd'>symbol</td><td class='ss'>price</td></tr>"
        @scrip_symbol.stub!(:text_range).and_return(@text)
        @scrip_symbol.values.should eql("Company Name,symbol,price\r\n,symbol,price")
    end
    
  end
  
  describe "setting company" do
    it "should replace any space from the company name with +" do
      @interface.company = 'new company'
      @interface.company.should eql('new+company')
    end
    
    it "should set changed to true if company has changed" do
      @interface.should_receive(:changed)
      @interface.company = 'new company'
    end
    
    it "should set changed to false if company has not changed" do
      @interface.should_receive(:changed).with(false)
      @interface.company = 'company name'
    end
    
    it "should notify any observers about the state of the object when company attribute is set" do
      @interface.should_receive(:notify_observers)
      @interface.company = 'company name'
    end
  end
  
end