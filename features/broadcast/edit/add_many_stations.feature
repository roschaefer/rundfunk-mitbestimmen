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
      | Title                    | Station   | Medium | Created at       | Updated at       |
      | Die Sendung mit der Maus | Das Erste | TV     | 2017-02-02 15:00 | 2017-02-02 15:00 |
 

  Scenario: Fix typo in description
    Given I visit the find broadcasts page
    And I click on the magnifier symbol next to "Die Sendung mit der Maus"
    And I click on the edit button
    When I add "WDR Fernsehen" to the list of stations
    And I add "KiKA" to the list of stations
    And I click on "Update"
    Then I see a success message:
    """
    Saved successfully
    """
    And the list of stations of "Die Sendung mit der Maus" now consists of:
      | Station       |
      | Das Erste     |
      | WDR Fernsehen |
      | KiKA          |

  Scenario: Fix Displayed updated at should include associations
    Given I am on the edit page for Broadcast "Die Sendung mit der Maus"
    When I add "WDR Fernsehen" to the list of stations
    And I click on "Update"
    Then on the broadcast page for "Die Sendung mit der Maus", I can see it was updated today
