@20
Feature: See leftover budget
  As a contributor
  I want to see if I have any remaining budget that I have not spent so far
  In order to spend all my budget completely

  Background:
    Given I am logged in

  Scenario: See remaining and total budget
    Given my invoice looks like this:
      | Title            | Amount | Fixed |
      | Tagesthemen      | €4.16  | no    |
      | Morgenmagazin    | €4.16  | no    |
      | Sportschau       | €4.16  | no    |
      | Tagesschau       | €5.00  | yes   |
    When I look at my invoice
    Then the main part of the invoice looks like this:
      | Title              | Amount   |
      | Tagesthemen        | €4.16    |
      | Morgenmagazin      | €4.16    |
      | Sportschau         | €4.16    |
      | Tagesschau         | €5.00    |
    And I see the remaining budget at the bottom of the invoice:
      | Label      | Amount |
      | Total:     | €17.48 |
      | Remaining: | €0.02  |
