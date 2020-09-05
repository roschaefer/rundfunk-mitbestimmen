Feature: Show some stats
  As a user
  I want to see on the landing page these numbers:
  * registered users
  * broadcasts
  * impressions
  * global sum of all amounts
  To be impressed and get a feeling how the total amount of monies compares to the broadcasting fees

  Scenario: Display stats
    Given there are 12 registered users
    And every user wants to pay 5 broadcasts each with €3.50 each
    When I visit the landing page
    Then I can see these numbers:
      | Registered users | Impressions | Already assigned |
      | 12               | 60          | €210             |
    And there is a link that brings me to the statistics page
