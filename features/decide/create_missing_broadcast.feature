@35
Feature: Create missing records
  As a user
  I want to create new broadcasts
  To add missing entries to the database

  Background:
    Given we have these stations:
      | Station | Medium |
      | Arte    | TV     |

 Scenario: A form appears if all broadcasts have been reviewed
    Given I am logged in
    And there are 3 broadcasts in the database
    And I visit the decision page
    When I click 'Yes' three times in a row
    Then message pops up, telling me I could reload more broadcasts
    And I click on "More suggestions"
    But then, the message is replaced with another one, requesting me this:
    """
    Just create a new broadcast!
    """
    And I see a form to enter a title and a description

 Scenario: Review all broadcasts and create a missing one
    Given I am logged in
    And I really like a broadcast called "Neo Magazin Royale"
    And I have reviewed all broadcasts already
    And I visit the decision page
    And the form to create a new broadcast is there
    When I enter the title "Neo Magazin Royale" with the following description:
    """
    Deutschlands einzige ernstzunehmende Unterhaltungsshow.
    """
    And I choose "TV" from the list of available media
    And I click on "Create"
    Then I can read:
    """
    Saved successfully
    """
    And a new broadcast was stored in the database with the data above

 Scenario: Create a broadcast and connect it to a TV station
    Given I am logged in
    And I want to create a new broadcast that does not exist yet
    When I enter the following data:
      | Title      | Medium | Station | Description                                                                    |
      | Metropolis | TV     | Arte    | Metropolis berichtet über das künstlerische und intellektuelle Leben in Europa |
    And I click on "Create"
    Then I can read:
    """
    Saved successfully
    """
    And the created broadcast has got the exact data from above


 Scenario: Guest users are asked to log in to create a new broadcast
    Given I am not logged in
    And I visit the decision page
    And there are no broadcasts in the database
    Then no form but a message is there, telling me:
    """
    If you log in, you can create new broadcasts
    """

