Feature: See station name on decision card
  As a user
  I want to see a small label with the logo of the station on the decision card
  Just to learn the station of the current broadcast - for orientation

  Background:
    Given we have these broadcasts in our database:
      | Title               | Station       | Medium |
      | Fernsehgarten       | ZDF           | TV     |

  Scenario: See the station's label
    When I visit the find broadcasts page
    Then I see that "Fernsehgarten" is aired on a "TV" station called "ZDF"
