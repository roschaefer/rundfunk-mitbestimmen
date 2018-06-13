Feature: FAQ page
  As a maintainer of the application
  I want a dedicated FAQ page with anchors
  So that I can send journalists and other users a deep-link into the FAQ

  Scenario: Navigate to the FAQ page
    Given I visit the landing page
    When I click on "Why do I have to login?"
    Then 