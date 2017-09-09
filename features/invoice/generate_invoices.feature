@9
Feature: Generate invoices
  As a user
  I want to generate an invoice including the selected broadcasts
  To say how much money should go to each item

  Background:
    Given I am logged in

  Scenario: Distribute money evenly among unassigned items
    Given I want to give money to each of these broadcasts:
      | Title                    |
      | Die Sendung mit der Maus |
      | Löwenzahn                |
      | Wissen macht Ah!         |
      | Tigerenten Club          |
      | Sandmann                 |
    When I visit the invoice page
    Then I can see that my budget of 17.50€ is distributed equally:
      | Title                    | Amount |
      | Die Sendung mit der Maus | 3.50   |
      | Löwenzahn                | 3.50   |
      | Wissen macht Ah!         | 3.50   |
      | Tigerenten Club          | 3.50   |
      | Sandmann                 | 3.50   |
    And also in the database all impressions have the same amount of "3.50"

