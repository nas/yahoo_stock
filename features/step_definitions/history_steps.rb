Given /^I do not have any historical data for the symbol "([^\"]*)"$/ do |scrip_symbol|
  @history = nil
end

When /^I get historical data for "([^\"]*)"$/ do |arg1|
  @history = YahooStock::History.new(:stock_symbol => 'msft', 
                                     :start_date => Date.today-10, 
                                     :end_date => Date.today-2)
  @results = @history.results
end

Then /^I should be able to get history results as a comma separated values in a string$/ do
  @results.output.should =~ /.*,.*/
end

Given /^I have the history results for the symbol "([^\"]*)"$/ do |stock_symbol|
  @history_format = YahooStock::History.new(:stock_symbol => stock_symbol,
                                            :start_date => Date.today-4, 
                                            :end_date => Date.today-2)
end

When /^I want to get the history results in array format$/ do
  @array_output = @history_format.results(:to_array).output
end

Then /^I should get an array of history values$/ do
  @array_output.should_not be_empty
end

When /^I want to get the history results in hash format$/ do
  @hash_output = @history_format.results(:to_hash).output
end

Then /^I should get an array of hash key values for history$/ do
  @hash_output.first.keys.should_not be_nil
end

When /^I want to get the history results in xml format$/ do
  @xml_output = @history_format.results(:to_xml).output
end

Then /^I should be able to get history result as xml$/ do
  @xml_output.should =~ /^\<xml*/
end