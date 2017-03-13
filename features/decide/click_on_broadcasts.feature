@6
Feature: Click on broadcasts
  As a user
  I want to click on Support or Next on a broadcast card
  In order to say whether I want to pay for the broadcast or not

  Background:
    Given I am logged in

  Scenario: Click on on Support and Next
    Given I have these broadcasts in my database:
      | Title       |
      | Quarks & Co |
      | Löwenzahn   |
      | Tagesschau  |
    When I visit the decision page
    And I decide 'Support' for Quarks & Co and Tagesschau but 'Next' for Löwenzahn
    Then the list of selectable broadcasts is empty
    And the database contains these selections that belong to me:
      | Title       | Answer  |
      | Quarks & Co | Support |
      | Löwenzahn   | Next    |
      | Tagesschau  | Support |

