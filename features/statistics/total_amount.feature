@28
Feature: Total amount of collected money per broadcast
  As a user
  I want to see how much money a broadcast has collected from all users on the platform
  To know how popular the broadcast is

  Scenario: Display total amount
    Given these users want to pay money for these broadcasts:
      | Email                        | Broadcast   | Amount |
      | erika.mustermann@example.org | Die Anstalt | €2.00  |
      | erika.mustermann@example.org | Heute Show  | €0.50  |
      | max.mustermann@example.org   | extra 3     | €1.50  |
      | max.mustermann@example.org   | Heute Show  | €1.00  |
      | lieschen.mueller@example.org | extra 3     | €3.00  |
      | lieschen.mueller@example.org | Heute Show  | €5.00  |
    When I visit the public statistics page
    Then I see this summary:
      | Broadcast   | Impressions | Approval | Average | Total |
      | Heute Show  | 3           | 100%     | €2.17   | €6.50 |
      | extra 3     | 2           | 100%     | €2.25   | €4.50 |
      | Die Anstalt | 1           | 100%     | €2.00   | €2.00 |
