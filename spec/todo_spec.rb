require "todotxt/todo"

describe Todotxt::Todo do

  it "should create a todo item string" do
    todo = Todotxt::Todo.new "an item"
    todo.to_s.should eql("an item")
  end

  it "should parse metadata when creating a simple item" do
    todo = Todotxt::Todo.new "x an item +project1 +project2 @context1 @context2"

    todo.to_s.should eql "x an item +project1 +project2 @context1 @context2"
    todo.priority.should eql nil
    todo.projects.should eql ["+project1", "+project2"]
    todo.contexts.should eql ["@context1", "@context2"]
    todo.done.should eql true
  end

  it "should parse metadata when creating an item with priority" do
    todo = Todotxt::Todo.new "(A) x an item +project1 +project2 @context1 @context2"

    todo.to_s.should eql "(A) x an item +project1 +project2 @context1 @context2"
    todo.priority.should eql "A"
    todo.projects.should eql ["+project1", "+project2"]
    todo.contexts.should eql ["@context1", "@context2"]
    todo.done.should eql true
  end

  it "should store line number when creating an item" do
    todo = Todotxt::Todo.new "an item", "2"

    todo.line.should eql "2"
  end

  it "should set an item as done" do
    todo = Todotxt::Todo.new "an item"

    todo.do

    todo.to_s.should eql "x an item"
    todo.done.should eql true
  end

  it "should set an item as not done" do
    todo = Todotxt::Todo.new "x an item"

    todo.undo

    todo.to_s.should eql "an item"
    todo.done.should eql false
  end

  it "should add priority to an item" do
    todo = Todotxt::Todo.new "an item"

    todo.prioritize "a"

    todo.to_s.should eql "(A) an item"
    todo.priority.should eql "A"
  end

  it "should change priority of an item" do
    todo = Todotxt::Todo.new "(A) an item"

    todo.prioritize "z"

    todo.to_s.should eql "(Z) an item"
    todo.priority.should eql "Z"
  end

  it "should remove priority from an item" do
    todo = Todotxt::Todo.new "(A) an item"

    todo.prioritize

    todo.to_s.should eql "an item"
    todo.priority.should eql nil
  end

  it "should append text to an item" do
    todo = Todotxt::Todo.new "an item"

    todo.append "more text"

    todo.to_s.should eql "an item more text"
  end

  it "should prepend text to an item" do
    todo = Todotxt::Todo.new "an item"

    todo.prepend "more text"

    todo.to_s.should eql "more text an item"
  end

  it "should preserve priority when prepending text to an item" do
    todo = Todotxt::Todo.new "(A) an item"

    todo.prepend "more text"

    todo.to_s.should eql "(A) more text an item"
    todo.priority.should eql "A"
  end

  it "should replace an item with new text" do
    todo = Todotxt::Todo.new "an item"

    todo.replace "(A) a replacement item"

    todo.to_s.should eql "(A) a replacement item"
    todo.priority.should eql "A"
  end

  it "should sort based on line number" do
    todo1 = Todotxt::Todo.new "an item 1", 1
    todo2 = Todotxt::Todo.new "an item 2", 2

    (todo1 <=> todo2).should eql -1
  end

  it "should value items with priority higher when sorting" do
    todo1 = Todotxt::Todo.new "an item 1", 1
    todo2 = Todotxt::Todo.new "(A) an item 2", 2

    (todo1 <=> todo2).should eql 1
  end

end
