require File.dirname(__FILE__) + '/../../spec_helper'

describe YahooStock::Result::XmlFormat do
  before(:each) do
    @data = "26.71,65620100,MSFT"
    @attributes = "price,volume,symbol"
  end
  
  describe ".new" do
    before(:each) do
      @hashed_format = stub('YahooStock::Result::HashFormat')
      YahooStock::Result::HashFormat.stub!(:new).and_return(@hashed_format)
    end
    
    it "should create the new hash object" do
      @hashed_format.stub!(:output)
      YahooStock::Result::HashFormat.should_receive(:new).with(@data){ @attributes }.and_return(@hashed_format)
      YahooStock::Result::XmlFormat.new(@data){@attributes}
    end
    
    it "should get the output of the hashed format" do
      @hashed_format.should_receive(:output)
      YahooStock::Result::XmlFormat.new(@data){@attributes}
    end
  end
  
  describe "#output" do
    before(:each) do
      @builder = stub('Builder::XmlMarkup')
      Builder::XmlMarkup.stub!(:new).and_return(@builder)
      @xml_format = YahooStock::Result::XmlFormat.new(@data){[:last_trade_price_only, :volume, :last_trade_date]}
      @builder.stub!(:instruct!)
      @builder.stub!(:items)
      @builder.stub!(:item)
    end
    
    it "should initialise the builder xml markup object" do
      Builder::XmlMarkup.should_receive(:new).and_return(@builder)
      @xml_format.output
    end
    
    it "should create the instruct for the xml" do
      @builder.should_receive(:instruct!)
      @xml_format.output
    end
    
    it "should create the root element called items" do
      @builder.should_receive(:items)
      @xml_format.output
    end
    
  end
  
end