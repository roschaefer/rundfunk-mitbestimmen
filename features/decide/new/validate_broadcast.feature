@60
Feature: Validate broadcasts
  As the maintainer of the database
  I want that users cannot create broadcasts without an acceptable description
  To enforce a minimum quality of the data

  ===
  Acceptance criteria:
  Description must be
  * present
  * minimum number of characters (e.g. 40)
  * no URLs (user should not leave the app, aka context switching)

  During user tests we learned that users click on `Save`, not knowing they
  create new broadcasts in the database: "Oops" :D

  Background:
    Given I am logged in

  Scenario: Stop lazy people from creating records
    Given I visit the find broadcasts page
    And I search for "Sylvesterstadl"
    And I get no search results
    But then the broadcast form pops up, encouraging me to create a new one
    And I see the input field filled out with the title I searched for
    When I just hit "Create"
    Then I get an error message
    """
    Description can't be blank
    """
    And because I'm lazy, I just submit the broadcast's official website
    """
    http://www.silvesterstadl.tv/stadl/
    """
    Then I get an error message
    """
    Description without links, please. Users should be able to vote [...]
    without leaving this website.
    """
    And no broadcast was saved to the database


