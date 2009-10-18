Given /^I know the name of the company "([^\"]*)"$/ do |company_name|
  @company_name = company_name
end

When /^I try to find the scrip symbols for "([^\"]*)"$/ do |arg1|
  @symbol = YahooStock::ScripSymbol.new(@company_name)
  @results = @symbol.results
end