@5
Feature: Basic User Accounts
  As a user
  I want to have an account
  To be credited for all the information that I publish on the app

  Scenario: Create an account
    Given there is no user in the database
    When I visit the landing page
    And I sign up
    Then my login was successful
    And a new user was created in the database

  Scenario: Log in with a legacy account
    Given I have signed up two months ago, prior to the migration to Auth0
    When I visit the landing page
    And I log in with my old credentials
    Then my login was successful
    But no other account was created


