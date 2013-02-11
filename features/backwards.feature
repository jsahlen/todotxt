Feature: Backwards compatibility

  So that I can continue using todotxt on an older system
  As a user
  I want to run todotxt with an old config

  Scenario: Running with an old config-file still works
    Given an old config exists
    And a todofile with the following items exists:
       | todo                  | 
       | Update my config file | 
    When I run `todotxt`
    Then it should pass with:
      """
      1. Update my config file
      """

  Scenario: Running with an old config-file and option --files fails
    Given an old config exists
    And a todofile with the following items exists:
      | todo                  |
      | Update my config file |
    When I run `todotxt --file=done`
    Then it should pass with exactly:
      """
      ERROR: You are using an old config, which has no support for mulitple files. Please update your configuration.

      """
