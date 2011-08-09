# Todotxt.rb

*todo.txt with a ruby flair*


## About

Todotxt is a ruby CLI interface to work with a
[todo.txt](http://www.todotxt.com) file


## Install

### From RubyGems.org

    gem install todotxt

### Manually

Clone from [jsahlen/todotxt](http://github.com/jsahlen/todotxt) and do

    rake install


## Configuration

Todotxt relies on a configuration file (`.todotxt.cfg`) in your home directory,
which points to the location of your todo.txt. You can run

    todotxt generate_cfg

to generate this file, which will then point to `~/todo.txt`.


## Usage

The gem will install a command, `todotxt` which is used to interact with your
todo.txt.

    Tasks:
      todotxt add | a TEXT                           # Add a new Todo item
      todotxt append | app ITEM# STRING              # Append STRING to ITEM#
      todotxt del | rm ITEM#[, ITEM#, ITEM#, ...]    # Remove ITEM#
      todotxt do ITEM#[, ITEM#, ITEM#, ...]          # Mark ITEM# as done
      todotxt dp | depri ITEM#[, ITEM#, ITEM#, ...]  # Remove priority for ITEM#
      todotxt generate_txt                           # Create a sample todo.txt
      todotxt generate_config                        # Create a .todotxt.cfg file in your home folder, containing the path to todo.txt
      todotxt help [TASK]                            # Describe available tasks or one specific task
      todotxt list | ls [SEARCH]                     # List all todos, or todos matching SEARCH
      todotxt listproj | lsproj                      # List all projects
      todotxt lscon | lsc                            # List all contexts
      todotxt lsdone | lsd                           # List all done items
      todotxt prepend | prep ITEM# STRING            # Prepend STRING to ITEM#
      todotxt pri | p ITEM# PRIORITY                 # Set priority of ITEM# to PRIORITY
      todotxt replace ITEM# TEXT                     # Completely replace ITEM# text with TEXT
      todotxt undo | u ITEM#[, ITEM#, ITEM#, ...]    # Mark ITEM# item as not done
      todotxt version                                # Show todotxt version    

Calling simply `todotxt` will automatically run the `ls` command.


## Screenshot

[Here](http://static.jsahlen.se/misc/todotxt_screenshot.png)

*Screenshot of Todotxt in a Terminal window using [Solarized](http://ethanschoonover.com/solarized) colors.*


## Dependencies

* [Thor](http://github.com/wycats/thor)
* [Rainbow](http://github.com/sickill/rainbow)
* [ParseConfig](http://www.5dollarwhitebox.org/drupal/?q=node/21)


## Bugs

Please report any bugs using the
[GitHub Issue Tracker](http://github.com/jsahlen/todotxt/issues).
