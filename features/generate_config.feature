Feature: Generate config file

  So that I can start using todotxt
  As a new user
  I want to create a config file

  Scenario: Generate a config file in an uninitialised environment
    Given an empty environment
    When I successfully run `todotxt generate_config`
    Then a file named ".todotxt.cfg" should exist

  Scenario: Attempt to override an existing config file
    Given a default config exists
    When I run `todotxt generate_config` interactively
    And I type "Y"
    Then it should pass with regexp:
      """
      Overwrite \/([^/]+\/)+.todotxt.cfg\?
      """
