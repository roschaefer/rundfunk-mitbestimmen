@23
Feature: Language chooser menu
  As a user
  I want to have a button to change the language
  In order to override the settings of my browser, e.g. if it's not my machine

  Scenario: Frontend is translated
    Given I visit the landing page
    And I see "Log in" and "Sign up" menu items
    When I click on the german flag
    Then I can see "Einloggen" and "Konto erstellen" menu items

  Scenario: Backend translates data
    Given I visit the landing page
    And I click on "Sign up"
    When I fill in an invalid email like "justcrap"
    And I click on the submit button
    Then I can see the error message in english:
    """
    Email is not an email
    """



