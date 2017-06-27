@195
Feature: Order Broadcasts
  As a user
  I want to order the broadcasts by name and have a button to switch between ascending/descending order
  Because that might be the way how I search for broadcasts

  Background:
    Given I am logged in

  Scenario: Check ascending
    When I visit the broadcasts page
    And  I see broadcasts in random order
    And  I visit the broadcasts page
    And  I see broadcasts in another random order
    And  I visit the broadcasts page
    And  I see broadcasts in another random order
    And  I click on the ascending button
    Then I see broadcasts ascending in order