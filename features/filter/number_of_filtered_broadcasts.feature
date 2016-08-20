@1
Feature: See number of filtered broadcasts
  As a fee payer
  I want to see how many broadcasts remain when I choose filter options
  In order to estimate how many broadcasts might be relevant to me

  Background:
    Given I am logged in

  Scenario: See number of unfiltered broadcasts
    Given I have these broadcasts in my database:
      | Title       | Topic     |
      | Quarks & Co | Education |
      | Löwenzahn   | Kids      |
      | Tagesschau  | News      |
    When I visit the filter page
    Then I can read we have '3 broadcasts in total'

