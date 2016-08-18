@5
Feature: Basic User Accounts
  As a user
  I want to have an account
  To be credited for all the information that I publish on the app

  Scenario: Create an account
    When I visit the landing page
    And I click on "Get started"
    And I fill in my email and password and confirm the password
    And I click on "Send"
    Then my login was successful
    And a new user was created in the database

  Scenario: Log in with an existing account
    Given I already signed up
    When I visit the landing page
    And I click on "Log in"
    And I fill in my email and password and click on 'Send'
    Then my login was successful


