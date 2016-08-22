@13
Feature: Pagination
  As a user
  I want to load more broadcasts on the decision page
  Because I am not tired and I want to make a decision on even more broadcasts

  Background:
    Given I am logged in

  Scenario: Click on 'more broadcasts'
    Given I have many broadcasts in my database, let's say 17 broadcasts in total
    And I visit the decision page
    And there are 10 remaining broadcasts in the list
    And I click 4 times on 'Yes'
    And there are 6 remaining broadcasts in the list
    When I click on "More broadcasts"
    Then the list of broadcasts has 10 items again
