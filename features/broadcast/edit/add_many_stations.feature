@time-travel
Feature: Add many stations
  As a broadcaster
  I want to add many stations to a broadcasts
  In order to help people to find the broadcast and to give give equal credit to stations

  Background:
    Given I am logged in
    And we have these stations:
      | Station       | Medium |
      | Das Erste     | TV     |
      | WDR Fernsehen | TV     |
      | KiKA          | TV     |
    And we have these broadcasts in our database:
      | Title                    | Station   | Medium |
      | Die Sendung mit der Maus | Das Erste | TV     |
 

  Scenario: Fix typo in description
    Given I visit the find broadcasts page
    And I click on the magnifier symbol next to "Die Sendung mit der Maus"
    And I click on the edit button
    When I add "WDR Fernsehen" to the list of stations
    And I add "KiKA" to the list of stations
    And I click on "Update"
    Then I can read:
    """
    Saved successfully
    """
    And the list of stations of "Die Sendung mit der Maus" now consists of:
      | Station       |
      | Das Erste     |
      | WDR Fernsehen |
      | KiKA          |

  Scenario: Fix Displayed updated at should include associations
    Given the current date is "2017-02-02"
    And we have these broadcasts in our database:
      | Title                    | Station   | Medium | Created at       | Updated at       |
      | Tom und Jerry            | Das Erste | TV     | 2017-02-02 15:00 | 2017-02-02 15:00 |
    And I am on the edit page for Broadcast "Tom und Jerry"
    When I add "WDR Fernsehen" to the list of stations
    And the current date is now
    And I click on "Update"
    And I am on the broadcast page for "Tom und Jerry"
    Then I can see Last updated at is not "02/02/2017"
