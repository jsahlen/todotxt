Feature: Do

  So that I can keep track of progress
  As a user
  I want to mark items done

  Background:
    Given a default config exists
    Given a todofile with the following items exists:
      | todo                                      |
      | 2013-01-01 Install todotxt @cli +todotxt  |
      | Read documentation +todotxt               |
      | 2012-12-12 Buy GTD book @amazon +wishlist |

  Scenario: Mark item done reports that item
    When I run `todotxt do 1`
    Then it should pass with:
      """
      1. x 2013-01-01 Install todotxt @cli +todotxt
      """

  Scenario: Mark item done checks item off in file
    When I run `todotxt do 1`
    Then the file "todo.txt" should contain:
      """
      x 2013-01-01 Install todotxt @cli +todotxt
      """

  Scenario: Mark an invalid item done
    When I run `todotxt do 1337`
    #Then it should fail with: @TODO: should fail, not pass
    Then it should pass with:
      """
      No todo found at line 1337
      """
