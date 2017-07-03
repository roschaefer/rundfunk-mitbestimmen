@195
Feature: Order Broadcasts
  As a user
  I want to order the broadcasts by name and have a button to switch between ascending/descending order
  Because that might be the way how I search for broadcasts

  Background:
    Given I am logged in
    And we have these broadcasts in our database:
      | Title           |
      | This            |
      | is just         |
      | an example      |
      | of six          |
      | broadcasts      |
      | in random order |

  Scenario: Check broadcast titles are ascending alphabetically
    Given I visit the find broadcasts page
    And  I see broadcasts in random order
    When I click on the button to order broadcasts in ascending order
    Then I see broadcasts ascending in order like this:
      | Title           |
      | an example      |
      | broadcasts      |
      | in random order |
      | is just         |
      | of six          |
      | This            |
