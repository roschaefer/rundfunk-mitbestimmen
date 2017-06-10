@13
Feature: Reload broadcasts
  As a user
  I want to load more broadcasts on the decision page
  Because I am not tired and I want to make a decision on even more broadcasts

  Background:
    Given I am logged in

  Scenario: Click on 'more broadcasts'
    Given we have 20 broadcasts in our database
    And I visit the decision page
    And I see 9 broadcasts to choose from
    When I click on "Next"
    And again, I see 9 broadcasts to choose from
    But when I click on "Next" once more
    Then I see 2 broadcasts to choose from
