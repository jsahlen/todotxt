Feature: Add items

  So that I can add new todos
  As a user
  I want to insert several new todos

  Background:
    Given a default config exists
    And a todofile exists

  Scenario: Adding a todo reports the added todo back to the user
    When I run `todotxt add "Make Coffee"`
    Then it should pass with:
      """
      Make Coffee
      """

  Scenario: Adding a todo inserts it into the file
    When I run `todotxt add "Make Coffee"`
    Then the file "todo.txt" should contain "Make Coffee"

  Scenario: Adding a todo with weird character adds it to the file
    When I run `todotxt add Äta gul snö`
    Then the file "todo.txt" should contain "Äta gul snö"
