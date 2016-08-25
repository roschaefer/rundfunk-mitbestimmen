@15 @future
Feature:
  As a user
  I want to see a fundraising progress bar per broadcast
  To see which broadcasts have enough and which broadcasts need funds urgently

  Background:
    Given there is a broadcast "Tagesschau" that costs 1,800€ per minute
    And the monthly costs are at 810,000€ as it is broadcasted every evening for 15 minutes

  Scenario: Show a fundraising progress bar
    Given other users contribute 405,000€ per month in total
    When I visit the bookkeeping page
    Then I can see a progress bar at 50% of raised funds

  Scenario: Link to invoice page for a broadcast that has already sufficient funds
    Given other users contribute more than 1,800€ per month in total
    And me too, I have decided to give 5€ per month to this broadcast
    When I visit the bookkeeping page
    Then I can see that "Tagesschau" has a surplus of funding
    And there is a link to the invoice page if I want to adjust my monthly contributions
