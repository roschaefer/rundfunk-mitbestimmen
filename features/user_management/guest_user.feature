@5
Feature: Allow guest accounts
  As a first-time user
  I want to use the app without registration
  So there is no barrier and I won't loose my interest

  Scenario: Guests can see suggestions without being logged in
    Given I have 13 broadcasts in my database
    When I visit the landing page
    And I click on "Participate now"
    Then I see the first suggestion
    But no account was created in the database

  Scenario: Responses to suggestions will be saved up account registration
    Given I responded 5 times with 'Yes' to a suggestion
    And at first, no selection and no account was created in the database
    When I click on "Sign up"
    And I fill in my email and password and confirm the password
    And I click on the submit button
    Then my login was successful
    Then my all my responses are saved in the database along with my account

  Scenario: Invoice will show question marks instead of amounts for guest users
    Given I responded 3 times with 'Yes' to a suggestion
    And I click on "Distribute budget"
    Then I see 3 invoice items with question marks instead of amounts
    And I am requested to sign up for the following reason:
    """
    Please sign up to make your voice count. This step is important to take your
    data seriously.
    """

  Scenario: Registration is possible on the invoice page
    Given I responded 3 times with 'Yes' to a suggestion
    And I click on "Distribute budget"
    When I click on one of the question marks and try to enter an amount
    And the modal with the sign up form shows up, telling me the following:
    """
    With your registration you show us that your data matters. Your data will be
    incorporated in the published results and that's how you gain an influence!
    """
    And I enter my login credentials and hit submit
    Then I will be redirected to the invoice page
    And my login was successful
    And all 3 amounts are distributed evenly
