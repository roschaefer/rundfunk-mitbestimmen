@102
Feature: Filter by station
  As a user
  I want to filter suggestions by radio or TV station
  To get more relevant results if I have a favourite station

  Background:
    Given we have these stations in our database:
      | Station       | Medium |
      | ZDF           | TV     |
      | Phoenix       | TV     |
      | WDR Fernsehen | TV     |
      | WDR 5         | Radio  |
    And we have these broadcasts in our database:
      | Title           | Station       | Medium |
      | Phoenix Runde   | Phoenix       | TV     |
      | Fernsehgarten   | ZDF           | TV     |
      | heute-journal   | ZDF           | TV     |
      | Quarks & Co     | WDR Fernsehen | TV     |
      | Leonardo        | WDR 5         | Radio  |
      | Frei.Willig.Weg |               | Online |
    And I visit the decision page

  Scenario: Choosing a medium will narrow down selectable stations
    When I filter by medium "Radio"
    Then the only station to choose from is "WDR 5"
    And the only broadcast I see is "Leonardo"

  Scenario: Filter for a station can yield just one result
    When I choose "Phoenix" from the list of "TV" stations
    Then the only broadcast I see is "Phoenix Runde"

  Scenario: Filter for a station can yield many results
    When I choose "ZDF" from the list of "TV" stations
    Then there are 2 remaining broadcasts
    And the displayed broadcast is either "Fernsehgarten" or "heute-journal"

  Scenario: The medium 'online' has no stations
    When I filter by medium "Online"
    Then there are no stations to choose from
    And the only broadcast I see is "Frei.Willig.Weg"

