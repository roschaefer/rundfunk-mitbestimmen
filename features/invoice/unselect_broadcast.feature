@11
Feature: Unselect broadcast
  As a user
  I want to be able to remove a broadcast from the list of broadcasts I want to pay for
  Because I have changed my mind

  Background:
    Given I am logged in

  Scenario: Click on the 'X' to remove a broadcast from the invoice
    Given my invoice looks like this:
      | Title            | Amount |
      | Tagesthemen      | €3.5   |
      | Morgenmagazin    | €3.5   |
      | Sportschau       | €3.5   |
      | Tagesschau       | €3.5   |
      | Blickpunkt Sport | €3.5   |
    When I look at my invoice and suddenly I don't like 'Sportschau' anymore
    And I click on the 'X' next to Sportschau
    Then my updated invoice looks like this:
      | Title            | Amount |
      | Tagesthemen      | €4.37  |
      | Morgenmagazin    | €4.37  |
      | Tagesschau       | €4.37  |
      | Blickpunkt Sport | €4.37  |
    And my response to "Sportschau" is listed in the database as "neutral"

