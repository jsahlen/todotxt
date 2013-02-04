Feature: Generate example todofile

  So that I can start using todotxt
  As a new user
  I want to create an example todofile

  Scenario: Generate a config file in an uninitialised environment
    Given an empty environment
    When I successfully run `todotxt generate_txt`
    Then a file named "todo.txt" should exist

  Scenario: Attempt to override an existing config file
    Given a default config exists
    And a todofile exists
    When I run `todotxt generate_txt` interactively
    And I type "Y"
    Then it should pass with regexp:
      """
      Overwrite \/([^/]+\/)+todo\.txt\?
      """
