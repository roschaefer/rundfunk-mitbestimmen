@23
Feature: Language chooser menu
  As a user
  I want to have a button to change the language
  In order to override the settings of my browser, e.g. if it's not my machine

  Background:
    Given we have these media:
      | Medium_en | Medium_de |
      | Other     | Sonstige  |

  Scenario: Frontend is translated
    Given I visit the landing page
    And I see the "Log in" menu item
    When I click on the german flag
    Then I see the "Einloggen" menu item

  Scenario: Backend translates to english
    Given I am logged in
    When I visit the find broadcasts page
    Then I see a medium called "Other"

  Scenario: Backend translates to german
    Given I am logged in
    When I visit the landing page
    And I click on the german flag
    And I click on "jetzt mitbestimmen"
    Then I see a medium called "Sonstige"


