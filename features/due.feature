Feature: Due

  So that I can see what needs to be done
  As a user
  I want to get a list of due items

  Background:
    Given a default config exists

  Scenario: List todays due
    Given the date is "2012-12-12"
    Given a todofile with the following items exists:
      | todo                                      |
      | 2013-01-01 Install todotxt @cli +todotxt  |
      | Read documentation +todotxt               |
      | 2012-12-12 Buy GTD book @amazon +wishlist |
    When I run `todotxt due` interactively
    Then it should pass with:
      """
      Due today (2012-12-12)
      3. 2012-12-12 Buy GTD book @amazon +wishlist
      """
