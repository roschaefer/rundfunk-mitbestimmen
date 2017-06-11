@79
Feature: Filter by medium
  As a contributor
  I want to filter by radio or TV
  To get more relevant results with a coarse filter and without limiting my results too extensively

  Background:
    Given I am logged in
    And we have these broadcasts in our database:
      | Title         | Medium |
      | Panorama      | TV     |
      | Refugee Radio | Radio  |
      | Protothon     | Other  |

  Scenario: Filter for radio broadcasts
    When I visit the find broadcasts page
    When I filter by medium "Radio"
    Then the only broadcast I see is "Refugee Radio"

  Scenario: Filter for other content
    When I visit the find broadcasts page
    When I filter by medium "Other"
    Then the only broadcast I see is "Protothon"

