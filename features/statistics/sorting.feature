@99
Feature: Sort descending/ascending by column
  As a user
  I want to sort by certain columns by clicking on the header
  In order to quickly find the broadcasts with the highest approval

  Background:
    Given the statistics look like this:
      | Broadcast   | Impressions | Approval | Average | Total |
      | Heute Show  | 3           | 100%     | €2.50   | €7.50 |
      | extra 3     | 2           | 50%      | €3.00   | €3.00 |
      | Die Anstalt | 10          | 20%      | €1.20   | €2.40 |

  Scenario: Sort ascending
    When I visit the public statistics page
    And I click on the header "Total" once
    Then the table is sorted ascending by column "Total"
    And I see this summary:
      | Broadcast   | Impressions | Approval | Average | Total |
      | Die Anstalt | 10          | 20%      | €1.20   | €2.40 |
      | extra 3     | 2           | 50%      | €3.00   | €3.00 |
      | Heute Show  | 3           | 100%     | €2.50   | €7.50 |

  Scenario: Sort by another column
    When I visit the public statistics page
    And I click on the header "Approval" once
    Then the table is sorted descending by column "Approval"
    And I see this summary:
      | Broadcast   | Impressions | Approval | Average | Total |
      | Heute Show  | 3           | 100%     | €2.50   | €7.50 |
      | extra 3     | 2           | 50%      | €3.00   | €3.00 |
      | Die Anstalt | 10          | 20%      | €1.20   | €2.40 |
