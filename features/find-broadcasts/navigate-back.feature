Feature: Navigate back and forth on find broadcasts
  As a user
  I want to avoid circular redirecting when clicking on back buttons
  In order to get back where I came from, e.g. after I edited a broadcast

  Background:
    Given there is a broadcast called "heute journal"
    And I am logged in

  Scenario: Navigate two levels deep and get back
    When I visit the find broadcasts page
    And I click on the magnifier symbol next to "heute journal"
    And I click on the edit button
    And I click on the back button
    But if I click on the close icon
    Then I am on the find broadcasts page
