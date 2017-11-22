@332
Feature: Support broadcasts after following a direct link
  As a user who just clicked a direct link to a broadcast, e.g. from a mediathek
  I want to click on "Support" immediately
  In order to change my response to positive

  Background:
    Given I am logged in
    And we have these broadcasts in our database:
      | ID   | Title       |
      | 4711 | Quarks & Co |

  Scenario: Just view, but don't support the broadcast
    When I visit "/broadcast/4711"
    And do nothing
    Then my responses in the database are like this:
      | Title       | Response |
      | Quarks & Co | neutral  |

  Scenario: Immediately click on Support
    When I visit "/broadcast/4711"
    And I click on "Support"
    Then my responses in the database are like this:
      | Title       | Response |
      | Quarks & Co | positive |
