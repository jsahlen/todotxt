Feature: Listing todos

  So that I can see what I have to do
  As a the user
  I want to list and filter my todos.

  Background:
    Given a default config exists
    And a todofile exists

  Scenario: List is default action
    When I run `todotxt`
    Then I should see all entries from the todofile with numbers

  Scenario: Show all entries
    When I run `todotxt list`
    Then I should see all entries from the todofile with numbers

  Scenario: Run with alias ls
    When I run `todotxt ls`
    Then I should see all entries from the todofile with numbers

  Scenario: Omits done tasks
    Given a todofile with done items exists
    When I run `todotxt list`
    Then the output should not match:
      """
      [\d]\.\s+x
      """
  Scenario: List done tasks
    Given a todofile with done items exists
    When I run `todotxt list --done`
    Then I should see all entries from the todofile with numbers
    When I run `todotxt list -d`
    Then I should see all entries from the todofile with numbers

  Scenario: Simple output for scripts
    When I run `todotxt list --simple`
    Then I should see all entries from the todofile without formatting

  Scenario Outline:
    Given a todofile with the following items exists:
      | todo                           |
      | Install todotxt @cli +todotxt  |
      | Read documentation +todotxt    |
      | Buy GTD book @amazon +wishlist |
    When I run `todotxt list <filter>`
    Then the output should match /.*<todos>.*/
    And the output should match /^TODO: <amount> items$/

    Examples:
      | filter  | todos                         | amount |
      | @cli    | Install todotxt | 1      |
      | +todotxt | Install todotxt .* Read documentation | 2 |
      | book     | Buy GTD book | 1 |
      | install  | Install todotxt | 1 | 
      | "Install todotxt" | Install todotxt | 1 |
      | foo-bar  |  | 0 |
      | "buy install" | | 0 |

