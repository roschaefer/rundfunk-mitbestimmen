@future
Feature: Display production costs
  As a user
  I want every broadcast to show its production cost
  To learn about it in the first place and maybe spend my money more equitable

  Scenario: Display costs per minute on the invoice page
    Given there is a broadcast "Tatort" that costs 15,500€ per minute
    And I already decided to give 1€ per month to this broadcast
    When I visit the invoice page
    Then I can see that it costs 15,500€ per minute
    And I am startled to see how expensive this is
