@38
Feature: Lead the user through the suggestions
  As a user
  I want to get a suggestion when a pile of decision cards runs out - issue the invoice or draw new cards?
  Because I do not know when it is a good moment to review the invoice

  Background:
    Given we have 10 broadcasts in our database
    And I am logged in
    When I visit the find broadcasts page

  Scenario: Tell the user to repeat until he finds enough broadcasts
    When I support 1 broadcast out of 6
    Then button to distribute the budget is only a secondary button

  Scenario: Tell the user to issue the invoice
    When I support 3 broadcasts out of 6
    Then the indicator of recently supported broadcasts says:
    """
    3 <3 recently supported broadcasts
    """
    And the button to distribute the budget has turned into a primary button


