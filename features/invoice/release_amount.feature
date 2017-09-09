@26
Feature: Release a fixed amount
  As a user
  I want to release a previously fixed amount and let the application take care of it
  Because I changed my mind and now I do not care anymore how much money a broadcast will receive

  Background:
    Given I am logged in

  Scenario: Release a fixed amount
    Given my broadcasts look like this:
      | Title            | Amount | Fixed |
      | Tagesthemen      | €3.00  | no    |
      | Morgenmagazin    | €3.00  | no    |
      | Sportschau       | €3.00  | no    |
      | Tagesschau       | €5.50  | yes   |
      | Blickpunkt Sport | €3.00  | no    |
    When I look at my broadcasts
    And I click on the unlock symbol next to "Tagesschau"
    Then my updated broadcasts look like this:
      | Title            | Amount |
      | Tagesthemen      | €3.50  |
      | Morgenmagazin    | €3.50  |
      | Sportschau       | €3.50  |
      | Tagesschau       | €3.50  |
      | Blickpunkt Sport | €3.50  |

  Scenario: Just set an amount fixed
    Given my broadcasts look like this:
      | Title            | Amount |
      | Tagesthemen      | €3.50  |
      | Morgenmagazin    | €3.50  |
      | Sportschau       | €3.50  |
      | Tagesschau       | €3.50  |
      | Blickpunkt Sport | €3.50  |
    And the attribute 'fixed' is "false" for my selected broadcast "Tagesschau"
    When I look at my broadcasts
    When I click on the lock symbol next to "Tagesschau"
    Then the attribute 'fixed' is "true" for my selected broadcast "Tagesschau"
