Feature: Initialize

  So that I can start using todotxt
  As a new user
  I want to set up example files

  Scenario: Completely clean system asks to create both config and todotxt
    When I run `todotxt` interactively
    And I type "yes"
    And I type "yes"
    Then it should pass with regexp:
      """
      Create \/(.*)\/\.todotxt.cfg\? \[y\/N\]
      """
    And it should pass with regexp:
      """
      Create \/(.*)\/todo.txt\? \[y\/N\]
      """

  Scenario: New installation asks and creates a config file
    When I run `todotxt` interactively
    And I type "yes"
    And I type "no"
    Then it should pass with:
      """
      .todotxt.cfg doesn't exist yet. Would you like to generate a sample file?
      """
    And a file named ".todotxt.cfg" should exist

  Scenario: New installation does not create a config file when I tell it not to
    When I run `todotxt` interactively
    And I type "no"
    Then a file named ".todotxt.cfg" should not exist

  Scenario Outline: New installation does not ask to create for certain options
    When I run `todotxt <option>`
    Then the output should not match:
      """
      \[y\/N\] \?
      """

    Examples:
       | option          |
       | help            |
       | generate_config |
       | generate_txt    |

  Scenario: New installation asks and creates a dummy todo.txt
    Given a default config exists
    When I run `todotxt` interactively
    And I type "yes"
    Then it should pass with:
      """
      todo.txt doesn't exist yet. Would you like to generate a sample file?
      """
    And a file named "todo.txt" should exist

  Scenario: New installation does not create a sample file when I tell it not to
    Given a default config exists
    When I run `todotxt` interactively
    And I type "no"
    Then a file named "todo.txt" should not exist
