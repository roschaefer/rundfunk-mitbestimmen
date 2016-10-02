@35
Feature: Create missing records
  As a user
  I want to create new broadcasts
  To add missing entries to the database

  Background:
    Given I am logged in

 Scenario: A form appears if all broadcasts have been reviewed
    Given there are 3 broadcasts in the database
    And I visit the decision page
    When I click 'Yes' three times in a row
    Then message pops up, telling me I could reload more broadcasts
    And I click on "Reload broadcasts"
    But then, the message is replaced with another one, requesting me this:
    """
    Just create a new broadcast!
    """
    And I see a form to enter a title and a description

 Scenario: Review all broadcasts and create a missing one
    Given I really like a broadcast called "Neo Magazin Royale"
    And I have reviewed all broadcasts already
    And I visit the decision page
    And the form to create a new broadcast is there
    When I enter the title "Neo Magazin Royale" with the following description:
    """
    Deutschlands einzige ernstzunehmende Unterhaltungsshow.
    """
    And I click on "Create"
    Then I can read:
    """
    Saved successfully
    """
    And a new broadcast was stored in the database with the data above
    And when I click on "Reload broadcasts" I can choose that broadcast

