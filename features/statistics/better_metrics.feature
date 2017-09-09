@63
Feature:
As a broadcaster
I want to see a ratio how many people like my broadcast and how much money people give on average
In order to infer the popularity of my broadcast and how important it is for my target group


  Background:
    Given 3 out of 10 users want to pay for a show called "Die Anstalt"
    And the total amount collected for this show is €15.00
    And 4 users of the app never viewed this show

  Scenario: Display number of impressions, satisfaction and average amount
    When I visit the public statistics page
    Then I see this summary:
      | Broadcast   | Impressions | Approval     | Average | Total  |
      | Die Anstalt | 10          | 30%          | €5.00   | €15.00 |

