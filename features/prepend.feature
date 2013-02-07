Feature: Prepend

  So that I can change items
  As a user
  I want to prepend text to an item

  Background:
    Given a default config exists
    And a todofile with the following items exists:
       | todo                               |
       | (B) Install todotxt @cli +todotxt  |
       | Drink coffee                       |

  Scenario: Add text to an item
    When I run `todotxt prepend 2 Brew and`
    Then it should pass with:
      """
      2. Brew and Drink coffee
      """
    And the file "todo.txt" should contain "Brew and Drink coffee"


  Scenario: Add text to an illegal item:
    When I run `todotxt prepend 1337 @sofa`
    Then it should pass with:
      """
      ERROR: No todo found at line 1337
      """
