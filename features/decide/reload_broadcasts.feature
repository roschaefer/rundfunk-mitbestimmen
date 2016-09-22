@13
Feature: Reload broadcasts
  As a user
  I want to load more broadcasts on the decision page
  Because I am not tired and I want to make a decision on even more broadcasts

  Background:
    Given I am logged in

  Scenario: Click on 'more broadcasts'
    Given I have many broadcasts in my database, let's say 17 broadcasts in total
    And I visit the decision page
    And I click 10 times on 'Yes'
    Then the stack of broadcasts is empty
    When I click on "Reload broadcasts"
    Then all of a sudden, there are more broadcasts again
