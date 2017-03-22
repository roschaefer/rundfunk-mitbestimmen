Feature:
  As a user
  I want an explanation above the table header
  In order to understand how a metric is computed

  Scenario: Click on accordion
    When I visit the public statistics page
    And I click the accordion on "Which formula is used to calculate the results?"
    And I click the accordion once again on "Approval"
    Then I can read:
    """
    From those people, who have viewed a broadcast, how many clicked on Support
    instead of Next?
    """

