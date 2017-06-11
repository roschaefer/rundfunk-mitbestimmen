@102
Feature: Filter by station
  As a user
  I want to filter suggestions by radio or TV station
  To get more relevant results if I have a favourite station

  Background:
    Given we have these stations in our database:
      | Station       | Medium |
      | Phoenix       | TV     |
      | WDR Fernsehen | TV     |
      | ZDF           | TV     |
      | WDR 5         | Radio  |
    And we have these broadcasts in our database:
      | Title               | Station       | Medium |
      | Phoenix Runde       | Phoenix       | TV     |
      | Fernsehgarten       | ZDF           | TV     |
      | heute-journal       | ZDF           | TV     |
      | Quarks & Co         | WDR Fernsehen | TV     |
      | Mitternachtsspitzen | WDR Fernsehen | TV     |
      | Rockpalast          | WDR Fernsehen | TV     |
      | Leonardo            | WDR 5         | Radio  |
      | Frei.Willig.Weg     |               | Online |
    And I visit the find broadcasts page

  Scenario: Choosing a medium will narrow down selectable stations
    When I filter by medium "Radio"
    Then the only station to choose from is "WDR 5"
    And the only broadcast I see is "Leonardo"

  Scenario: Filter for a station can yield just one result
    When I choose "Phoenix" from the list of "TV" stations
    Then the only broadcast I see is "Phoenix Runde"

  Scenario: Filter for a station can yield many results
    When I choose "ZDF" from the list of "TV" stations
    Then there are 2 remaining broadcasts, namely "Fernsehgarten" and "heute-journal"

  Scenario: The medium 'online' has no stations
    When I filter by medium "Online"
    Then there are no stations to choose from
    And the only broadcast I see is "Frei.Willig.Weg"

  Scenario: Stations are sorted by their broadcasts count in descending order
    Given we have some more stations:
      | Station       | Medium | #Broadcasts |
      | rbb fernsehen | TV     | 5           |
      | BR Fernsehen  | TV     | 9           |
      | SWR           | TV     | 4           |
    And I visit the find broadcasts page
    When I filter by medium "TV"
    When I click on the stations dropdown menu
    Then the stations are ordered like this:
      | Station       |
      | BR Fernsehen  |
      | rbb fernsehen |
      | SWR           |
      | WDR Fernsehen |
      | ZDF           |
      | Phoenix       |

  @116
  Scenario: Removing filter options will extend the number of results again
    When I choose "Phoenix" from the list of "TV" stations
    Then there is just one result
    But when I unselect the station
    Then there are 6 results
    And when I unselect the medium
    Then there are 8 results
