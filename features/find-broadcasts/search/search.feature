@33
Feature: Search on find broadcasts page
  As a user
  I want to search the list of broadcasts by title
  To find my favourite shows

  Background:
    Given I am logged in

  Scenario: Search by title
    Given I have 10 broadcasts in my database
    And one broadcast with title "Search for: keyword"
    And I visit the find broadcasts page
    And I see 6 broadcasts to choose from
    When I search for "keyword"
    Then there is exactly one search result
    And the only displayed broadcast has the title:
    """
    Search for: keyword
    """

  Scenario: Sort by title after searching
    Given we have these broadcasts in our database:
      | Title              |
      | Mickey Mouse Film  |
      | Popeye Film        |
      | Tom und Jerry Film |
      | I am different     |
    And I visit the find broadcasts page
    When I search for "Film"
    And I click on "alphabetical_order_descending"
    Then there are exactly 3 search results
    And the results are ordered like this:
      | Title               |
      | Tom und Jerry Film  |
      | Popeye Film         |
      | Mickey Mouse Film   |
