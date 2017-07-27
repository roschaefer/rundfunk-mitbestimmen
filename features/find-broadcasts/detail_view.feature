@121
Feature: Link to broadcast details page on every broadcast card
  As a user who is currently choosing which broadcsts to support
  I would like to see a detailed view when I click on a certain button on the card
  In order to focus on the information of that broadcast

  Background:
    Given I am logged in
    And we have these broadcasts in our database:
      | Title                | Medium | Station   | Created at | Updated at | Description                                                    |
      | Sportschau           | TV     | Das Erste | 2017-07-27 | 2017-08-01 | Fußball-Bundesliga und vieles mehr.                            |
      | Medienmagazin        | Radio  | radioeins | 2017-07-27 | 2017-08-01 | Welche Zukunft hat die ARD? Antworten gibt's im Medienmagazin. |
      | Sendung mit der Maus | TV     | WDR       | 2017-07-27 | 2017-08-01 | Lach und Sachgeschichten mit der Maus und dem Elefanten.       |
  Scenario: Click on details button to get to broadcast details page
    Given I visit the find broadcasts page
    When I click on title of the broadcast card of "Medienmagazin"
    Then I see only this broadcast an nothing else, in order to stay focused
    And I see even more details of "Medienmagazin" like:
      | Created at     | Last updated at |
      | 27th July 2017 | 1st August 2017 |
