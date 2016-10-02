@35
Feature: Create missing records
  As a user
  I want to create new broadcasts
  To add missing entries to the database

  Background:
    Given I am logged in

 Scenario: Review all broadcasts and create a missing one
    Given I really like a broadcast called "Neo Magazin Royale"
    And I have reviewed all broadcasts already
    And I visit the decision page
    And the form to create a new broadcast is there
    When I enter the title "Neo Magazin Royale" with the following description:
    """
    Deutschlands einzige ernstzunehmende Unterhaltungsshow.
    """
    And I click on "Save"
    Then I can read:
    """
    Saved successfully
    """
    And a new broadcast was stored in the database with the data above
    And when I click on "Reload broadcasts" I can choose that broadcast

