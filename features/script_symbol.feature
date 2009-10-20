Feature: Find Script Symbols
	As a user
	I want to find the script symbols for a company
	So that I can use in other classes
	Scenario: Find Scrip Symbols
		Given I know the name of the company "Yahoo"
		When I try to find the scrip symbols for "Yahoo"
		Then I should be able to get scrip symbol results as a comma separated values in a string
		
	Scenario: Get symbol results in array format
		Given I have the scrip symbol results for the symbol "yhoo"
		When I want to get the scrip symbol results in array format
		Then I should get an array of values for scrip symbol

	Scenario: Get symbol results in hash format
		Given I have the scrip symbol results for the symbol "yhoo"
		When I want to get the scrip symbol results in hash format
		Then I should get an array of hash key values for scrip symbol

	Scenario: Get symbol results in xml format
		Given I have the scrip symbol results for the symbol "yhoo"
		When I want to get the scrip symbol results in xml format
		Then I should be able to get scrip symbol result as xml