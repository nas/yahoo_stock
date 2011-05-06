require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe YahooStock::Result::ArrayFormat do
  
  describe "output" do
    
    it "should return an array for each line and each line with an array of csv" do
      string = "asdfsdf,as,f asf s\r\n23,sdf,2332,sdf"
      YahooStock::Result::ArrayFormat.new(string).output.should eql([['asdfsdf','as','f asf s'],['23','sdf' ,'2332', 'sdf']])
    end
    
  end
  
end