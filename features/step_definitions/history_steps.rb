Given /^I do not have any historical data for the symbol "([^\"]*)"$/ do |scrip_symbol|
  @history = nil
end

When /^I get historical data for "([^\"]*)"$/ do |arg1|
  @history = YahooStock::History.new(:stock_symbol => 'msft', 
                                     :start_date => Date.today-10, 
                                     :end_date => Date.today-2)
end
