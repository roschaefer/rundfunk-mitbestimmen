@99
Feature: Sort descending/ascending by column
  As a user
  I want to sort by certain columns by clicking on the header
  In order to quickly find the broadcasts with the highest approval

  Background:
    Given the balances look like this:
      | Broadcast   | Reviews | Approval | Per capita | Total |
      | Heute Show  | 3       | 100%     | 2.50€      | €7.50 |
      | extra 3     | 2       | 50%      | 3.00€      | €3.00 |
      | Die Anstalt | 10      | 20%      | 1.20€      | €2.40 |

  Scenario: Sort ascending
    When I visit the public balances page
    And I click on the header "Total" once
    Then the table is sorted ascending by column "Total"
    And I see this summary:
      | Broadcast   | Reviews | Approval | Per capita | Total |
      | Die Anstalt | 10      | 20%      | 1.20€      | €2.40 |
      | extra 3     | 2       | 50%      | 3.00€      | €3.00 |
      | Heute Show  | 3       | 100%     | 2.50€      | €7.50 |

  Scenario: Sort by another column
    When I visit the public balances page
    And I click on the header "Approval" once
    Then the table is sorted descending by column "Approval"
    And I see this summary:
      | Broadcast   | Reviews | Approval | Per capita | Total |
      | Heute Show  | 3       | 100%     | 2.50€      | €7.50 |
      | extra 3     | 2       | 50%      | 3.00€      | €3.00 |
      | Die Anstalt | 10      | 20%      | 1.20€      | €2.40 |
