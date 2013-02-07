Feature: Depri, remove priority

  So that I can make tasks less important
  As a user
  I want to remove the priorities

  Background:
    Given a default config exists
    And a todofile with the following items exists:
       | todo                               |
       | (B) Install todotxt @cli +todotxt  |
       | Drink coffee                       |

  Scenario: Remove priority of an item
    When I run `todotxt depri 1`
    Then it should pass with:
      """
      1. Install todotxt @cli +todotxt
      """
    And the file "todo.txt" should contain exactly:
      """
      Install todotxt @cli +todotxt
      Drink coffee
      """

  Scenario: Remove the priority of an unprioritized item
    When I run `todotxt depri 2`
    Then it should pass with:
      """
      2. Drink coffee
      """

  Scenario: Remove the priority of an illegal item
    When I run `todotxt depri 1337`
    Then it should pass with:
       """
       ERROR: No todo found at line 1337
       """
