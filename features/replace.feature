Feature: Replace

  So that I can change items
  As a user
  I want to completely replace an item with new text

  Background:
    Given a default config exists
    And a todofile with the following items exists:
       | todo                               |
       | (B) Install todotxt @cli +todotxt  |
       | Drink coffee                       |

  Scenario: Add text to an item
    When I run `todotxt replace 2 sip frappucino @buckstar`
    Then it should pass with:
      """
      2. sip frappucino @buckstar
      """
    And the file "todo.txt" should contain "sip frappucino @buckstar"
    And the file "todo.txt" should not contain "Drink coffee"

  Scenario: Add text to an illegal item:
    When I run `todotxt prepend 1337 @sofa`
    Then it should pass with:
      """
      ERROR: No todo found at line 1337
      """
