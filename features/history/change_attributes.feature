Feature: Change attributes retrospectively
  As a user
  I want to change the attributes of a broadcast in the list of all my reviewed broadcasts
  In order to fix typos and add missing information

  Background:
    Given I am logged in

  Scenario: Fix typo in description
    Given I reviewed the broadcast "heute journal" with this description:
    """
    Das heute-journal: politische Berichte, schwachsinnige Analysen und rätselhafte Erklärungen.
    """
    When I visit my history page
    And I click on the magnifier symbol next to "heute journal"
    And I click on the edit button
    And I change the description to:
    """
    Das heute-journal: politische Berichte, scharfsinnige Analysen und verständliche Erklärungen.
    """
    And I click on "Update"
    Then this better description was saved
