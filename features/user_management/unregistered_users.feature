@5
Feature: Unregistered users
  As a first-time user
  I want to be informed that without login, the statistics won't be valuable
  In order to understand the necessity to register

  Scenario: Guests can see suggestions in the background without being logged in
    Given I have 13 broadcasts in my database
    When I visit the landing page
    And I click on "participate now"
    Then I am greeted with the login screen
    And the login screen says: "Without registration, people would leave duplicate data"
    And I see the first suggestion hardly visible in the background
