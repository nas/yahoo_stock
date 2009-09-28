require File.dirname(__FILE__) + '/../spec_helper'

describe YahooStock::ScripSymbol do
  describe ".results" do
    before(:each) do
      @company = stub('ScripSymbol')
      @result = YahooStock::Result.new('cst')
      YahooStock::ScripSymbol.stub!(:new).and_return(@company)
      @company.stub!(:results).and_return(@result)
    end
    it "should create ScripSymbol instance for each company name" do
      YahooStock::ScripSymbol.should_receive(:new).with('company1').and_return(@company)
      YahooStock::ScripSymbol.should_receive(:new).with('company2').and_return(@company)
      YahooStock::ScripSymbol.results('company1', 'company2')
    end
    
    it "find results for each company" do
      @company.should_receive(:results).twice.and_return(@result)
      YahooStock::ScripSymbol.results('company1', 'company2')
    end
    
    it "should concatenate the results of all company names and then initialize the YahooStock::Result object" do
      company2 = stub('ScripSymbol')
      @result2 = YahooStock::Result.new('qwe')
      company2.stub!(:results).and_return(@result2)
      YahooStock::ScripSymbol.stub!(:new).with('company1').and_return(@company)
      YahooStock::ScripSymbol.stub!(:new).with('company2').and_return(company2)
      YahooStock::Result.should_receive(:new).with("cst\nqwe\n")
      YahooStock::ScripSymbol.results('company1', 'company2')
    end
  end
  
  describe "data_attributes" do
    before(:each) do
      @symbol = YahooStock::ScripSymbol.new('company name')
    end
    it "should return an array of data attributes" do
      @symbol.data_attributes.should be_instance_of(Array)
    end
    
    it "should have following data attributes" do
      @symbol.data_attributes.should include('Symbol', 'Name', 'Last Trade', 'Type', 'Industry Category', 'Exchange')
    end
  end

end
