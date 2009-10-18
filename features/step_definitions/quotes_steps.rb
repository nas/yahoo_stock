Given /^I do not have any quote results$/ do
  @quote = nil
end

When /^I want to get the quotes for the symbol "([^\"]*)"$/ do |stock_symbol|
  @quote = YahooStock::Quote.new(:stock_symbols => stock_symbol)
  @results = @quote.results
end

Then /^I should be able to get results as a comma separated values in a string$/ do
  @results.output.should =~ /.*,.*/
end

Given /^I have the results for the symbol "([^\"]*)"$/ do |stock_symbol|
  @quote_format = YahooStock::Quote.new(:stock_symbols => stock_symbol)
end

When /^I want to get the results in array format$/ do
  @array_output = @quote_format.results(:to_array).output
end

Then /^I should get an array of values$/ do
  @array_output.should_not be_empty
end

Then /^by default there should only be two values$/ do
  @array_output.size.should eql(2)
end

When /^I want to get the results in hash format$/ do
  @hash_output = @quote_format.results(:to_hash).output
end

Then /^I should get an array of hash key values$/ do
  @hash_output.first.keys.should include(:last_trade_price_only, :last_trade_date)
end

When /^I want to get the results in xml format$/ do
  @xml_output = @quote_format.results(:to_xml).output
end

Then /^I should be able to get result as xml$/ do
  @xml_output.should =~ /^\<xml*/
end

