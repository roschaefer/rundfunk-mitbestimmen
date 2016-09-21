@34
Feature: Display one broadcast at a time
  As a user
  I want to see one decision card at a time
  Otherwise there is too much distraction

  Background:
    Given I am logged in

  Scenario: First item fully displayed and next two items mimized
    Given I have 17 broadcasts in my database
    When I visit the decision page
    Then I see the buttons to click 'Yes' or 'No' only once, respectively
    And the first card on the stack is fully displayed
    But the cards below are not displayed, only the title of the next two cards

