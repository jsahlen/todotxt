Feature: Append

  So that I can change items
  As a user
  I want to append text to an item

  Background:
    Given a default config exists
    And a todofile with the following items exists:
       | todo                               |
       | (B) Install todotxt @cli +todotxt  |
       | Drink coffee                       |

  Scenario: Add text to an item
    When I run `todotxt append 2 @sofa`
    Then it should pass with:
      """
      2. Drink coffee @sofa
      """
    And the file "todo.txt" should contain "Drink coffee @sofa"


  Scenario: Add text to an illegal item:
    When I run `todotxt append 1337 @sofa`
    Then it should pass with:
      """
      ERROR: No todo found at line 1337
      """
