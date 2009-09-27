require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe YahooStock::Result::ArrayFormat do
  
  describe "output" do
    before(:each) do
      @data = "asdf\"sdf,as,f\" asf s"
      @array_format = YahooStock::Result::ArrayFormat.new(@data)
    end
    
    it "should remove all double quotes from the data string" do
      @data.should_receive(:gsub).with(/\"/,'').and_return('a string')
      @array_format.output
    end
    
    it "should create array element for each line by splitting it for the line break" do
      string = "asdfsdf,as,f asf s"
      @data.stub!(:gsub).and_return(string)
      string.should_receive(:split).with(/\r\n|\n/).and_return([])
      @array_format.output
    end
    
    it "should create a sub array for each line by splitting them for each comma" do
      string = "asdfsdf,as,f asf s"
      @data.stub!(:gsub).and_return(string)
      string.stub!(:split).with(/\r\n|\n/).and_return([string])
      string.should_receive(:split).with(',').and_return([])
      @array_format.output
    end
    
    it "should return an array for each line and each line with an array of csv" do
      string = "asdfsdf,as,f asf s\r\n23,sdf,2332,sdf"
      @data.stub!(:gsub).and_return(string)
      @array_format.output.should eql([['asdfsdf','as','f asf s'],['23','sdf' ,'2332', 'sdf']])
    end
  end
  
end