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

  Scenario: Invoice will show question marks instead of amounts for guest users
    Given I responded 3 times with 'Support' to a suggestion
    When I click on "Distribute budget"
    Then a modal pops up, telling me the following:
    """
    Sign up to continue
    """

  Scenario: Registration is possible on the invoice page
    Given I responded 3 times with 'Support' to a suggestion
    And I click on "Distribute budget"
    And I make the modal go away
    When I click on one of the euro icons to enter an amount
    And the modal pops up again, asking me to register
    And I finally sign up
    Then I will be redirected to the invoice page
    And my login was successful
    And all my responses are saved in the database along with my account
    And all 3 amounts are distributed evenly
