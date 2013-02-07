Feature: Edit

  So that I can modify my entire todolist
  As a user
  I want to open the todofile in my editor


  Background:
    Given a todofile with the following items exists:
      | todo                                      |
      | 2013-01-01 Install todotxt @cli +todotxt  |
      | Read documentation +todotxt               |
      | 2012-12-12 Buy GTD book @amazon +wishlist |

  Scenario: Open the file in the systems editor
    Given the enviromnent variable "EDITOR" is set to "echo"
    And a default config exists
    When I run `todotxt edit`
    Then it should pass with:
     """
     todo.txt
     """

  Scenario: Open the file in the configured editor
    Given a default config exists with the editor set to "echo"
    When I run `todotxt edit`
    Then it should pass with:
      """
      todo.txt
      """

