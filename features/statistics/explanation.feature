Feature:
  As a user
  I want an explanation above the table header
  In order to understand how a metric is computed

  Scenario: Click on accordion
    When I visit the public statistics page
    And I click the accordion on "Explain these metrics, please"
    And I click the accordion once again on "Approval"
    Then I can read:
    """
    From those people, who got a broadcast suggested, how many clicked on Support instead of Next?
    The formula is (in number of clicks): support/(support + next)
    """

