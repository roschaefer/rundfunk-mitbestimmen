@13
Feature: Reload broadcasts
  As a user
  I want to load more broadcasts on the find broadcasts page
  Because I am not tired and I want to make a decision on even more broadcasts

  Background:
    Given I am logged in

  Scenario: Click on 'more broadcasts'
    Given we have 14 broadcasts in our database
    And I visit the find broadcasts page
    And I see 6 broadcasts to choose from
    When I click on "Next"
    And again, I see 6 broadcasts to choose from
    But when I click on "Next" once more
    Then I see 2 broadcasts to choose from
