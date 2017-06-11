Feature: Distinguish radio and TV shows
  As a user
  I want to have a small label "radio" or "TV" on the decision card
  To know if the broadcast is a radio or a TV show

  Background:
    Given I am logged in
    And we have these media:
      | Medium |
      | TV     |
      | Radio  |

  Scenario: Check radio or TV as a medium
    Given I have these broadcasts in my database:
      | Title          | Medium |
      | Babo-Bus       | Radio  |
    When I visit the find broadcasts page
    Then a label indicates the medium 'Radio' on the decision card

  Scenario: Create a radio broadcast
    When I want to create a new broadcast
    And I type in "Babo-Bus" and choose "Radio" as medium
    And I fill in a description and hit submit
    Then I see "Saved successfully"
    And a new radio broadcast is created in the database
