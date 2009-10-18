Feature: Get quotes for a stock
	As a user
	I want to get the stock quotes
	So that I can use them in different formats
	Scenario: Get stock quotes
		Given I do not have any quote results
		When I want to get the quotes for the symbol "yhoo"
		Then I should be able to get results as a comma separated values in a string
	
	Scenario: Get results in array format
		Given I have the results for the symbol "yhoo"
		When I want to get the results in array format
		Then I should get an array of values
	
	Scenario: Get results in hash format
		Given I have the results for the symbol "yhoo"
		When I want to get the results in hash format
		Then I should get an array of hash key values
	
	Scenario: Get results in xml format
		Given I have the results for the symbol "yhoo"
		When I want to get the results in xml format
		Then I should be able to get result as xml