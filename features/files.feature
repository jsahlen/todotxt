Feature: Files

  So that I can organise my Todo-items better
  As a user
  I want to use different files

  Background:
    Given a config exists with the following files:
      | alias    | path         |
      | todo     | todo.txt     | 
      | wishlist | wishlist.txt | 
    And a todofile with the following items exists:
      | todo                     | 
      | Read book on GTD         | 
      | Publish wishlist on site | 
    And a todofile named "wishlist.txt" with the following items exists:
      | todo                               |
      | Getting Things Done @bookstore     |
      | Label Maker @officesupply          |

  Scenario: Run list with --files option
    When I run `todotxt list --file=wishlist`
    Then it should pass with:
      """
      Getting Things Done @bookstore
      """

  Scenario: Provide a file that is not in the config
    When I run `todotxt list --file=doesnotexist` interactively
    Then it should fail with:
      """
      \"doesnotexist\" is not defined in the config
      """

  Scenario: Run list with --files option and a filename for a file not in the config
    Given a todofile named "deferred.txt" with the following items exists:
      | todo                               |
      | Getting Things Done @bookstore     |
    When I run `todotxt list --file=./deferred.txt`
    Then it should pass with:
      """
      Getting Things Done @bookstore
      """

  Scenario: List entries from all files
    When I run `todotxt list --all`
    Then it should pass with:
      """
      1. Read book on GTD
      2. Publish wishlist on site
      3. Getting Things Done @bookstore
      4. Label Maker @officesupply
      """
