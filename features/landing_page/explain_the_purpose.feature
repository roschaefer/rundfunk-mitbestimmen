@2
Feature: Explain the purpose
  As a visitor
  I want to see a short paragraph of text with general information on the landing page
  To understand the purpose of the app

  Scenario:
    When I visit the landing page
    Then I can read:
    """
    You pay €17.50 per month. Don't you want to have a say?
    """
