@46
Feature: Go back one decision card
  As a user
  I want to have a 'Back' button on the find broadcasts page
  To fix an error e.g. I pushed the button 'Next' but that was by accident


  Background:
    Given I am logged in

  Scenario: Revise on decision
    Given I have 20 broadcasts in my database:
    When I visit the find broadcasts page
    And I click on "Next", but missed a broadcast which I like
    And in the database all my responses are 'neutral'
    But then I click on "Back"
    And support the first broadcast
    Then the first broadcast turns green
    And I have one positive response in the database
