@121
Feature: Show broadcast modal on click
  As a user
  I would like to see a detailed view whenever I click on the title of a broadcast
  In order to recap and see the description of that broadcast again

  Background:
    Given I am logged in
    And we have these broadcasts in our database:
      | Title                | Medium | Station   | Created at | Updated at | Description                                                    |
      | Sportschau           | TV     | Das Erste | 2017-07-27 | 2017-08-01 | Fußball-Bundesliga und vieles mehr.                            |
      | Medienmagazin        | Radio  | radioeins | 2017-07-27 | 2017-08-01 | Welche Zukunft hat die ARD? Antworten gibt's im Medienmagazin. |
      | Sendung mit der Maus | TV     | WDR       | 2017-07-27 | 2017-08-01 | Lach und Sachgeschichten mit der Maus und dem Elefanten.       |

  Scenario: Show details on "My broadcasts" page
    Given my votes look like this:
      | Title                | Support | Amount |
      | Sportschau           | No      | -      |
      | Medienmagazin        | Yes     | €7.50  |
      | Sendung mit der Maus | Yes     | €10.00 |
    When I visit the 'My broadcasts' page
    And I ask myself: What was "Medienmagazin" about?
    And I click on the title "Medienmagazin"
    Then I can see these details:
      | Title       | Medienmagazin                                                  |
      | Medium      | Radio                                                          |
      | Station     | radioeins                                                      |
      | Created at  | 2017-07-27                                                     |
      | Updated at  | 2017-08-01                                                     |
      | Description | Welche Zukunft hat die ARD? Antworten gibt's im Medienmagazin. |

  Scenario: Show details on "Find broadcasts" page
    Given I visit the find broadcasts page
    When I click on the button to see the details page of "Medienmagazin"
    Then to stay focused, I see only this broadcast
    And I see even more details of "Medienmagazin", like:
      | Created at     | Last updated at |
      | 27th July 2017 | 1st August 2017 |
