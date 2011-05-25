require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe YahooStock::Result::HashFormat do
  before(:each) do
    @data = 'da,ta'
    @array_format = YahooStock::Result::ArrayFormat.new(@data)
  end
  describe ".new" do
    it "should initialise the Array Format class with data" do
      YahooStock::Result::ArrayFormat.should_receive(:new).and_return(@array_format)
      YahooStock::Result::HashFormat.new(@data){[:key1, :key2]}
    end
    
    it "should get the output of the array format" do
      YahooStock::Result::ArrayFormat.stub!(:new).and_return(@array_format)
      @array_format.should_receive(:output)
      YahooStock::Result::HashFormat.new(@data){[:key1, :key2]}
    end
    
    it "should yield the block" do
      hash_format = YahooStock::Result::HashFormat.new(@data){['key1', 'key2']}
      hash_format.keys.should eql([:key1, :key2])
    end
  end
  
  
  describe "output" do
    it "should have the data as a hash with keys key1 and key2" do
      hash_format = YahooStock::Result::HashFormat.new(@data){['key1', 'key2']}
      hash_format.output.should eql([{:key1 => 'da',:key2 => 'ta'}])
    end
    
    it "should have the data as an array of hashes with the same keys key1 and key2" do
      data = "da,ta\nda,ta\nda,ta"
      hash_format = YahooStock::Result::HashFormat.new(data){['key1', 'key2']}
      hash_format.output.should eql([{:key1 => 'da',:key2 => 'ta'},
                                     {:key1 => 'da',:key2 => 'ta'},
                                     {:key1 => 'da',:key2 => 'ta'}
                                    ])
    end
    
    it "should properly parse data with commas" do
      data = "da,\"t,a\"\nda,\"t,a\"\nda,\"t,a\""
      hash_format = YahooStock::Result::HashFormat.new(data){['key1', 'key2']}
      hash_format.output.should eql([{:key1 => 'da',:key2 => 't,a'},
                                     {:key1 => 'da',:key2 => 't,a'},
                                     {:key1 => 'da',:key2 => 't,a'}
                                    ])
    end
  end
  
  describe "keys" do
    it "should replace white space characters to underscore in the keys" do
      hash_format = YahooStock::Result::HashFormat.new(@data){['ke y 1', 'k e y 2']}
      hash_format.keys.should eql([:ke_y_1, :k_e_y_2])
    end
    
    it "should replace upper case characters to lower case in the keys" do
      hash_format = YahooStock::Result::HashFormat.new(@data){['Key1', 'keY2']}
      hash_format.keys.should eql([:key1, :key2])
    end
  end
  
  
end