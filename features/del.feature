Feature: delete

  So that I can change my mind
  As a user
  I want to remove items from the todolist

  Background:
    Given a default config exists
    And a todofile with the following items exists:
       | todo                               |
       | (B) Install todotxt @cli +todotxt  |
       | Drink coffee                       |
       | x Make coffee                      |

  Scenario: Remove item with confirmation
    When I run `todotxt del 2` interactively
    And I type "Y"
    Then it should pass with:
      """
      2. Drink coffee
      Remove this item? [y/N] => Removed from list
      """
    And the file "todo.txt" should not contain "Drink coffee"

  Scenario: Remove several items with confirmation
    When I run `todotxt del 1 2` interactively
    And I type "Y"
    And I type "Y"
    Then it should pass with:
       """
       1. (B) Install todotxt @cli +todotxt
       Remove this item? [y/N] => Removed from list
       2. Drink coffee
       Remove this item? [y/N] => Removed from list
       """
    And the file "todo.txt" should not contain "(B) Install todotxt @cli +todotxt"
    And the file "todo.txt" should not contain "Drink coffee"

  Scenario: Remove item without confirmation
    When I run `todotxt del 2 -f`
    Then it should pass with:
       """
       2. Drink coffee
       => Removed from list
       """

  Scenario: Attempt to delete an illegal item
    When I run `todotxt del 1337`
    Then it should pass with:
      """
      ERROR: No todo found at line 1337
      """
