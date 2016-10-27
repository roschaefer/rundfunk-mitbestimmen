@79
Feature: Filter by medium
  As a contributor
  I want to filter by radio or TV
  To get more relevant results with a coarse filter and without limiting my results too extensively

  Background:
    Given I am logged in
    And we have these broadcasts in our database:
      | Title         | Medium |
      | Panorama      | tv     |
      | Refugee Radio | radio  |
      | Protothon     | other  |

  Scenario: Uncheck tv icon to see only radio broadcasts
    When I visit the decision page
    And I click on the tv icon
    Then the tv icon is disabled
    And the only broadcast I see is "Refugee Radio"

  Scenario: Uncheck radio and tv icon to see special content
    When I visit the decision page
    And I click on the tv icon
    And I click on the radio icon
    Then both radio and tv icons are disabled
    And the only thing I see is "Protothon"
