Feature: Undo

  So that I can fix mistakes
  As a user
  I want to mark items as not done

  Background:
    Given a default config exists
    Given a todofile with the following items exists:
       | todo                                       |
       | x 2013-01-01 Install todotxt @cli +todotxt |
       | x Read documentation +todotxt              |
       | 2012-12-12 Buy GTD book @amazon +wishlist  |

  Scenario: Undo a single item reports it back and marks it as not done in the file
    When I run `todotxt undo 2`
    Then it should pass with:
      """
      2. Read documentation +todotxt
      """
    And the file "todo.txt" should contain exactly:
      """
      x 2013-01-01 Install todotxt @cli +todotxt
      Read documentation +todotxt
      2012-12-12 Buy GTD book @amazon +wishlist
      """

  Scenario: Undo multiple items
    When I run `todotxt undo 1 2`
    Then it should pass with:
      """
      1. 2013-01-01 Install todotxt @cli +todotxt
      2. Read documentation +todotxt
      """
    And the file "todo.txt" should contain exactly:
      """
      2013-01-01 Install todotxt @cli +todotxt
      Read documentation +todotxt
      2012-12-12 Buy GTD book @amazon +wishlist
      """

  Scenario: Undo an item that was not marked as done
    When I run `todotxt undo 3`
    Then it should pass with:
    """
    3. 2012-12-12 Buy GTD book @amazon +wishlist
    """

  Scenario: Undo invalid items
    When I run `todotxt undo 1337`
    Then it should pass with:
      """
      ERROR: No todo found at line 1337
     """
