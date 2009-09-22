require File.dirname(__FILE__) + '/../spec_helper'

describe YahooStock::ScripSymbol do
  
  describe ".print_options" do
    before(:each) do
      @symbol = stub(YahooStock::ScripSymbol)
      @script_symbol = YahooStock::ScripSymbol.stub!(:new).and_return(@symbol)
    end
    
    it "should find scrip symbol for one company" do
      @symbol.should_receive(:find).once.and_return([])
      YahooStock::ScripSymbol.print_options('company1')
    end
    
    it "should find scrip symbols for two companies" do
      @symbol.should_receive(:find).twice.and_return([])
      YahooStock::ScripSymbol.print_options('company1', 'company2')
    end
    
    it "should return nil" do
      @symbol.should_receive(:find).and_return([])
      YahooStock::ScripSymbol.print_options('company1').should eql(nil)
    end
    
    it "should print the results for each scrip or company, i.e twice" do
      scrip = ['name','stock']
      @symbol.stub!(:find).and_return([scrip])
      YahooStock::ScripSymbol.should_receive(:p).with(scrip).twice
      YahooStock::ScripSymbol.print_options('company1','company2')
    end
    
    it "should print the results for each scrip or company, 4times" do
      scrip = ['name','stock']
      @symbol.stub!(:find).and_return([scrip,scrip])
      YahooStock::ScripSymbol.should_receive(:p).with(scrip).exactly(4)
      YahooStock::ScripSymbol.print_options('company1','company2')
    end
  end
  
  describe ".save_options_to_file" do
    before(:each) do
      @symbol = stub(YahooStock::ScripSymbol)
      @script_symbol = YahooStock::ScripSymbol.stub!(:new).and_return(@symbol)
      @file = stub(File)
      @file_name = 'file_name'
    end
    
    it "should create or open a file with file name parameter and appends to it" do
      File.should_receive(:open).with(@file_name, 'a')
      YahooStock::ScripSymbol.save_options_to_file('file_name', 'company1')
    end
    
    it "should find scrip symbol for one company" do
      @symbol.should_receive(:find).once.and_return([])
      YahooStock::ScripSymbol.save_options_to_file(@file_name,'company1')
    end

    it "should find scrip symbols for two companies" do
      @symbol.should_receive(:find).twice.and_return([])
      YahooStock::ScripSymbol.save_options_to_file(@file_name, 'company1','company2')
    end
    
    it "should have one option for each company in the file" do
      scrip = ['name','stock']
      @symbol.stub!(:find).and_return([scrip])
      YahooStock::ScripSymbol.save_options_to_file(@file_name, 'company1','company2')
      file_data.should eql(["name, stock\n", "name, stock\n"])
    end
    
    it "should have two option for each company in the file" do
      scrip = ['name','stock']
      @symbol.stub!(:find).and_return([scrip, scrip])
      YahooStock::ScripSymbol.save_options_to_file(@file_name, 'company1','company2')
      file_data.should eql(["name, stock\n", "name, stock\n", "name, stock\n", "name, stock\n"])
    end
    
    def file_data
      File.open(@file_name, 'r') { |f| return f.readlines }
    end
    
    after(:each) do
      File.delete(@file_name) if File.exists? @file_name
    end
    
  end
  
end
