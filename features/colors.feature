Feature: Colors and markup

  So that I can glance over my todos
  As a user
  I want to see output colored and highlighted

  Background:
    Given a default config exists
    Given a todofile with the following items exists:
       | todo                     | 
       | Drink Coffee             | 
       | Sip Frappucino @buckstar | 
       | Lurk Americano +break    | 
       | x brew coffee            | 
       | (A) Order coffee         |
       | (B) Pay coffee           |
       | (C) Pick up coffee       |
       | (D) Thank for service    |

  @ansi
  Scenario: See todos with a bright, dark number and uncolored todo-text
    When I successfully run `todotxt list Drink`
    Then it should output "1. " brightly in "black"
    And the output should contain "Drink Coffee"

  @ansi
  Scenario: See todo-count in bright dark letters
    When I successfully run `todotxt list Drink`
    Then it should output "TODO: 1 items" brightly in "black"

  @ansi
  Scenario: See contexts in blue
    When I successfully run `todotxt list @buckstar`
    Then it should output "@buckstar" in "blue"

  @ansi
  Scenario: See projects in green
    When I successfully run `todotxt list +break`
    Then it should output "+break" in "green"

  @ansi
  Scenario Outline:
    When I successfully run `todotxt list (<priority>)`
    Then it should output "(<priority>) " in "<color>"
  Examples:
     | priority | color  | 
     | A        | red    | 
     | B        | yellow | 
     | C        | green  | 
     | D        | white  | 

