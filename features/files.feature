Feature: Files

  So that I can organise my Todo-items better
  As a user
  I want to use different files

  Background:
    Given a config exists with the following files:
      | alias    | path         |
      | todo     | todo.txt     | 
      | wishlist | wishlist.txt | 
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

  @wip
  Scenario: Provide a file that is not in the config
    When I run `todotxt list --file=doesnotexist`
    Then it should fail with:
      """
      \"doesnotexist\" is not a defined in the config
      """
