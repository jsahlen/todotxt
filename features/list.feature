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
    Then it should count <amount> TODO-items

    Examples:
        | filter            | todos                                 | amount |
        | @cli              | Install todotxt                       | 1      |
        | +todotxt          | Install todotxt .* Read documentation | 2      |
        | book              | Buy GTD book                          | 1      |
        | install           | Install todotxt                       | 1      |
        | "Install todotxt" | Install todotxt                       | 1      |
        | foo-bar           |                                       | 0      |
        | "buy install"     |                                       | 0      |

  Scenario: List is sorted by priority
    Given a todofile with the following items exists:
       | todo                               |
       | (B) Install todotxt @cli +todotxt  |
       | Drink coffee                       |
       | (A) Read documentation +todotxt    |
       | (C) Buy GTD book @amazon +wishlist |
    When I run `todotxt list`
    Then it should pass with:
      """
      3. (A) Read documentation +todotxt
      1. (B) Install todotxt @cli +todotxt
      4. (C) Buy GTD book @amazon +wishlist
      2. Drink coffee
      """

  @todo
  Scenario: List is sorted by date
    Given a todofile with the following items exists:
      | todo                                      |
      | 2013-01-01 Install todotxt @cli +todotxt  |
      | Read documentation +todotxt               |
      | 2012-12-12 Buy GTD book @amazon +wishlist |
    When I run `todotxt list`
    Then it should pass with:
      """
      3. 2012-12-12 Buy GTD book @amazon +wishlist
      1. 2013-01-01 Install todotxt @cli +todotxt
      2. Read documentation +todotxt
      """

  Scenario: List all done items
    Given a todofile with the following items exists:
      | todo                           |
      | x Buy GTD book @amazon +wishlist |
      | Install todotxt @cli +todotxt  |
      | x Read documentation +todotxt    |
    When I run `todotxt lsdone`
    Then it should pass with:
      """
      1. x Buy GTD book @amazon +wishlist
      3. x Read documentation +todotxt
      """
    Then it should count 2 TODO-items
    When I run `todotxt lsd`
    Then it should count 2 TODO-items

  Scenario: List all projects
    Given a todofile with the following items exists:
      | todo                           |
      | Buy GTD book @amazon +wishlist |
      | Install todotxt @cli +todotxt  |
      | Read documentation +todotxt    |
    When I run `todotxt lsproj`
    Then it should pass with:
      """
      +todotxt
      +wishlist
      """

  Scenario: List all contexts
    Given a todofile with the following items exists:
      | todo                           |
      | Install todotxt @cli +todotxt  |
      | Buy GTD book @amazon +wishlist |
      | Read documentation +todotxt    |
    When I run `todotxt lscon`
    Then it should pass with:
      """
      @amazon
      @cli
      """
