@5
Feature: Allow guest accounts
  As a first-time user
  I want to use the app without registration
  So there is no barrier and I won't loose my interest

  Scenario: Guests can see suggestions without being logged in
    Given I have 13 broadcasts in my database
    When I visit the landing page
    And I click on "participate now"
    Then I see the first suggestion
    But no account was created in the database

  Scenario: Responses to suggestions will be saved up account registration
    Given I responded 5 times with 'Support' to a suggestion
    And at first, no selection and no account was created in the database
    When I sign up
    Then I am back on the decision page
    And all my responses are saved in the database along with my account

  Scenario: Unregistered users will be asked to sign up first before they distribute their budget
    When I click the support button for every broadcast in the database
    Then I can see a button "Sign up" with a message next to it:
    """
    To distribute your symbolic budget of €17.50, please sign up.
    """
    And if I click on that button and create an account
    Then all my responses are saved in the database along with my account
    And I am brought to the 'My broadcasts' page
    And I can see all my selected broadcasts

