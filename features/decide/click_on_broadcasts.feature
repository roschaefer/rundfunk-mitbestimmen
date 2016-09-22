@6
Feature: Click on broadcasts
  As a user
  I want to click on Yes or No on a broadcast card
  In order to say whether I want to pay for the broadcast or not

  Background:
    Given I am logged in

  Scenario: Click on on Yes and No
    Given I have these broadcasts in my database:
      | Title       |
      | Quarks & Co |
      | Löwenzahn   |
      | Tagesschau  |
    When I visit the decision page
    And I decide 'Yes' for Quarks & Co and Tagesschau but 'No' for Löwenzahn
    Then the list of selectable broadcasts is empty
    And I the database contains these selections that belong to me:
      | Title       | Answer |
      | Quarks & Co | Yes    |
      | Löwenzahn   | No     |
      | Tagesschau  | Yes    |

