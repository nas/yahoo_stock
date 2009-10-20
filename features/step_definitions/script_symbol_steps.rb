Given /^I know the name of the company "([^\"]*)"$/ do |company_name|
  @company_name = company_name
end

When /^I try to find the scrip symbols for "([^\"]*)"$/ do |company_name|
  @symbol = YahooStock::ScripSymbol.new(company_name)
end

Then /^I should be able to get scrip symbol results as a comma separated values in a string$/ do
  @symbol.results.output.should =~ /.*,.*/
end

Given /^I have the scrip symbol results for the symbol "([^\"]*)"$/ do |company|
  @symbol_format = YahooStock::ScripSymbol.new(company)
  @results = @symbol_format.results
end

When /^I want to get the scrip symbol results in array format$/ do
  @array_output = @symbol_format.results(:to_array).output
end

Then /^I should get an array of values for scrip symbol$/ do
  @array_output.should_not be_empty
end

When /^I want to get the scrip symbol results in hash format$/ do
  @hash_output = @symbol_format.results(:to_hash).output
end

Then /^I should get an array of hash key values for scrip symbol$/ do
   @hash_output.first.keys.should_not be_nil
end

When /^I want to get the scrip symbol results in xml format$/ do
  @xml_output = @symbol_format.results(:to_xml).output
end

Then /^I should be able to get scrip symbol result as xml$/ do
  @xml_output.should =~ /^\<xml*/
end