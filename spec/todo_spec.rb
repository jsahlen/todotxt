require "spec_helper"
require "todotxt/todo"

describe Todotxt::Todo do

  it "creates a todo item string" do
    todo = Todotxt::Todo.new "an item"
    todo.to_s.should eql("an item")
  end

  it "parses metadata when creating a simple item" do
    todo = Todotxt::Todo.new "x an item +project1 +project2 @context1 @context2"

    todo.to_s.should eql "x an item +project1 +project2 @context1 @context2"
    todo.priority.should eql nil
    todo.projects.should eql ["+project1", "+project2"]
    todo.contexts.should eql ["@context1", "@context2"]
    todo.done.should eql true
  end

  it "parses metadata when creating an item with priority" do
    todo = Todotxt::Todo.new "(A) x an item +project1 +project2 @context1 @context2"

    todo.to_s.should eql "(A) x an item +project1 +project2 @context1 @context2"
    todo.priority.should eql "A"
    todo.projects.should eql ["+project1", "+project2"]
    todo.contexts.should eql ["@context1", "@context2"]
    todo.done.should eql true
  end

  it "stores line number when creating an item" do
    todo = Todotxt::Todo.new "an item", "2"

    todo.line.should eql "2"
  end

  it "sets an item as done" do
    todo = Todotxt::Todo.new "an item"

    todo.do

    todo.to_s.should eql "x an item"
    todo.done.should eql true
  end

  it "sets an item as not done" do
    todo = Todotxt::Todo.new "x an item"

    todo.undo

    todo.to_s.should eql "an item"
    todo.done.should eql false
  end

  it "adds priority to an item" do
    todo = Todotxt::Todo.new "an item"

    todo.prioritize "a"

    todo.to_s.should eql "(A) an item"
    todo.priority.should eql "A"
  end

  it "changes priority of an item" do
    todo = Todotxt::Todo.new "(A) an item"

    todo.prioritize "z"

    todo.to_s.should eql "(Z) an item"
    todo.priority.should eql "Z"
  end

  it "removes priority from an item" do
    todo = Todotxt::Todo.new "(A) an item"

    todo.prioritize

    todo.to_s.should eql "an item"
    todo.priority.should eql nil
  end

  it "appends text to an item" do
    todo = Todotxt::Todo.new "an item"

    todo.append "more text"

    todo.to_s.should eql "an item more text"
  end

  it "prepends text to an item" do
    todo = Todotxt::Todo.new "an item"

    todo.prepend "more text"

    todo.to_s.should eql "more text an item"
  end

  it "preserves priority when prepending text to an item" do
    todo = Todotxt::Todo.new "(A) an item"

    todo.prepend "more text"

    todo.to_s.should eql "(A) more text an item"
    todo.priority.should eql "A"
  end

  it "replaces an item with new text" do
    todo = Todotxt::Todo.new "an item"

    todo.replace "(A) a replacement item"

    todo.to_s.should eql "(A) a replacement item"
    todo.priority.should eql "A"
  end

  it "sorts based on line number" do
    todo1 = Todotxt::Todo.new "an item 1", 1
    todo2 = Todotxt::Todo.new "an item 2", 2

    (todo1 <=> todo2).should eql -1
  end

  it "values items with priority higher when sorting" do
    todo1 = Todotxt::Todo.new "an item 1", 1
    todo2 = Todotxt::Todo.new "(A) an item 2", 2

    (todo1 <=> todo2).should eql 1
  end

end
