@28
Feature: Total amount of collected money per broadcast
  As a user
  I want to see how much money a broadcast has collected from all users on the platform
  To know how popular the broadcast is

  Scenario: Visit public balances page
    Given these users want to pay money for these broadcasts:
      | Email                        | Broadcast   | Amount |
      | erika.mustermann@example.org | Die Anstalt | €2.00  |
      | erika.mustermann@example.org | Heute Show  | €0.50  |
      | max.mustermann@example.org   | extra 3     | €1.50  |
      | max.mustermann@example.org   | Heute Show  | €1.00  |
      | lieschen.mueller@example.org | extra 3     | €3.00  |
      | lieschen.mueller@example.org | Heute Show  | €5.00  |
    When I visit the public balances page
    Then I see this summary:
      | Broadcast   | Upvotes | Total |
      | Heute Show  | 3       | €6.50 |
      | extra 3     | 2       | €4.50 |
      | Die Anstalt | 1       | €2.00 |
