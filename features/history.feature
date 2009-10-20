Feature: Find historical stock data for a stock
	As a user
	I want to find historical data for a stock
	So that I can use the historical data
	Scenario: Get historical data
		Given I do not have any historical data for the symbol "msft"
		When I get historical data for "msft"
		Then I should be able to get history results as a comma separated values in a string
	
	Scenario: Get results in array format
		Given I have the history results for the symbol "yhoo"
		When I want to get the history results in array format
		Then I should get an array of history values
	
	Scenario: Get results in hash format
		Given I have the history results for the symbol "yhoo"
		When I want to get the history results in hash format
		Then I should get an array of hash key values for history
	
	Scenario: Get results in xml format
		Given I have the history results for the symbol "yhoo"
		When I want to get the history results in xml format
		Then I should be able to get history result as xml