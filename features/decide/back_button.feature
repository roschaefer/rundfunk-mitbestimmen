@46
Feature: Go back one decision card
  As a user
  I want to have a 'Back' button on the decision page
  To fix an error e.g. I pushed the button 'Next' but that was by accident


  Background:
    Given I am logged in

  Scenario: Revise on decision
    Given I have these broadcasts in my database:
      | Title       |
      | Quarks & Co |
      | Löwenzahn   |
    And I visit the decision page
    And I click 'Next' when I am asked if I want to pay for the broadcast
    When the decision card has disappeared
    Then I can still click on the 'Back' button
    And click 'Yes, I do!'
    And the decision card turns green
    And in the database my response is saved as 'positive'
