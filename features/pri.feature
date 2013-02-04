Feature: Prioritise

  So that I can make items more important
  As a user
  I want to prioritise items

  Background:
    Given a default config exists
    And a todofile with the following items exists:
       | todo                               |
       | (B) Install todotxt @cli +todotxt  |
       | Drink coffee                       |

  Scenario: Set priority of an item should report it and change it in the file
    When I run `todotxt pri 2 A`
    Then it should pass with:
      """
      2. (A) Drink coffee
      """
    And the file "todo.txt" should contain "(A) Drink coffee"

  Scenario: Set the priority of an already prioritised item
    When I run `todotxt pri 1 A`
    Then the file "todo.txt" should contain "(A) Install todotxt @cli +todotxt"

  #todo: make it throw an error instead.
  Scenario: Attempt to set priority to an illegal priority
    When I run `todotxt pri 2 Foo`
    Then it should pass with:
      """
      2. Drink coffee
      """
    And the file "todo.txt" should not contain "(Foo) Drink coffee"

  Scenario: Attempt to set the priority of an illegal line
    When I run `todotxt pri 1337 A`
    Then it should pass with:
       """
       ERROR: No todo found at line 1337
       """
