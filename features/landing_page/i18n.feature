@3
Feature: I18n
  As a user
  I want to change the language
  Because I might not be fluent in english

  @de
  Scenario:
    Given my browser language is set to german
    When I visit the landing page
    Then I am welcomed with "Hallo!"
