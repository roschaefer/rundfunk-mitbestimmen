@6
Feature: Click on broadcasts
  As a user
  I want to click on Support or have a neutral default on a broadcast card
  In order to say whether I want to pay for the broadcast or not

  Background:
    Given I am logged in

  Scenario: Click on on Support and Next
    Given I have these broadcasts in my database:
      | Title       |
      | Quarks & Co |
      | Löwenzahn   |
      | Tagesschau  |
    When I visit the find broadcasts page
    And I support Quarks & Co and Tagesschau but not Löwenzahn
    Then my responses in the database are like this:
      | Title       | Response |
      | Quarks & Co | positive |
      | Löwenzahn   | neutral  |
      | Tagesschau  | positive |

