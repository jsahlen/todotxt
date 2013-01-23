Feature: Initialize

  So that I can start using todotxt
  As a new user
  I want to set up example files

  Background:
    Given a home directory

  Scenario: New installation asks and creates a config file
    When I run `todotxt` interactively
    And I type "yes"
    Then it should pass with:
      """
      You need a .todotxt.cfg file in your home folder to continue (used to determine the path of your todo.txt.) Answer yes to have it generated for you (pointing to ~/todo.txt), or no to create it yourself.
      """
    And a file named ".todotxt.cfg" should exist

  Scenario: New installation does not create a config file when I tell it not to
    When I run `todotxt` interactively
    And I type "no"
    Then a file named ".todotxt.cfg" should not exist
