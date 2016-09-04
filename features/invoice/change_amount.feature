@18
Feature: Change amount
  As a contributor
  I want to click on my invoice table and edit the amount
  To say precisely how much money I want to give to certain broadcasts

  Background:
    Given I am logged in

  Scenario: Click on the amount to change it
    Given my invoice looks like this:
      | Title            | Amount |
      | Tagesthemen      | €3.50  |
      | Morgenmagazin    | €3.50  |
      | Sportschau       | €3.50  |
      | Tagesschau       | €3.50  |
      | Blickpunkt Sport | €3.50  |
    When I look at my invoice and I feel that "Tagesschau" is more important to me
    When I change the amount of "Tagesschau" to "5.50" euros
    Then my updated invoice looks like this:
      | Title            | Amount |
      | Tagesthemen      | €3.00  |
      | Morgenmagazin    | €3.00  |
      | Sportschau       | €3.00  |
      | Tagesschau       | €5.50  |
      | Blickpunkt Sport | €3.00  |

  Scenario: Once changed invoice items are fixed and keep their amounts
    Given my invoice looks like this:
      | Title            | Amount | Fixed |
      | Tagesthemen      | €3.00  | no    |
      | Morgenmagazin    | €3.00  | no    |
      | Sportschau       | €3.00  | no    |
      | Tagesschau       | €5.50  | yes   |
      | Blickpunkt Sport | €3.00  | no    |
    When I look at my invoice
    When I change the amount of "Morgenmagazin" to "6.00" euros
    Then my updated invoice looks like this:
      | Title            | Amount |
      | Tagesthemen      | €2.00  |
      | Morgenmagazin    | €6.00  |
      | Sportschau       | €2.00  |
      | Tagesschau       | €5.50  |
      | Blickpunkt Sport | €2.00  |

