require "spec_helper"
require "todotxt/todolist"

describe Todotxt::TodoList do

  describe "with simple list" do
    before :each do
      @list = Todotxt::TodoList.new File.join(File.dirname(__FILE__), "fixtures", "simple_todo.txt")
    end

    it "parses a file on creation" do
      @list.todos[0].to_s.should eql "First item"
      @list.todos[1].to_s.should eql "Second item"
      @list.todos[2].to_s.should eql "Third item"
      @list.todos[3].to_s.should eql "x First done item"

      @list.todos[0].line.should eql 1
      @list.todos[1].line.should eql 2
      @list.todos[2].line.should eql 3
      @list.todos[3].line.should eql 4
    end

    it "adds a new item" do
      @list.add "Fourth item"

      @list.todos[4].to_s.should eql "Fourth item"
      @list.todos[4].line.should eql 5
    end

    it "removes an item" do
      @list.remove 1

      @list.todos[0].to_s.should eql "Second item"
    end

    it "finds item by line" do
      todo = @list.find_by_line 3

      todo.to_s.should eql "Third item"
    end

    it "filters list when searching" do
      @list.filter "First"

      @list.todos.count.should eql 1
    end

    it "filters list when searching case-sensitive" do
      @list.filter "first"

      @list.todos.count.should eql 1
    end

    it "includes done items in search when told to do so" do
      @list.filter "first", :with_done => true

      @list.todos.count.should eql 2
    end

    it "only includes done items in search when told to do so" do
      @list.filter "first", :only_done => true

      @list.todos.count.should eql 1
    end

    it "renders plain text" do
      comparison_string = <<EOF
First item
Second item
Third item
x First done item
EOF
      @list.to_txt.should eql comparison_string.strip
    end
  end

  describe "with complex list" do
    before :each do
      @list = Todotxt::TodoList.new File.join(File.dirname(__FILE__), "fixtures", "complex_todo.txt")
    end

    it "sorts itself automatically on parse" do
      @list.todos[0].to_s.should eql "(A) an item"
      @list.todos[0].line.should eql 3
    end

    it "re-sorts itself after adding a new item" do
      @list.add "(B) A new item"

      @list.todos[1].to_s.should eql "(B) A new item"
      @list.todos[1].line.should eql 4
    end

    it "lists all projects and contexts in the list" do
      @list.projects.should eql ["+project1", "+project2"]
      @list.contexts.should eql ["@context1", "@context2"]
    end
  end

end
