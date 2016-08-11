@3
Feature: I18n
  As a user
  I want to change the language
  Because I might not be fluent in english

  @wip
  Scenario:
    Given my browser is set to "de"
    When I visit the landing page
    Then I am welcomed with "Hallo!"
