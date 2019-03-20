require 'spec_helper'
require 'todotxt/todolist'
require 'todotxt/todofile'

describe Todotxt::TodoList do
  describe 'with simple list' do
    before :each do
      @file = Todotxt::TodoFile.new File.join(File.dirname(__FILE__), 'fixtures', 'simple_todo.txt')
      @list = Todotxt::TodoList.new @file
    end

    it 'parses a file on creation' do
      expect(@list.todos[0].to_s).to match('First item')
      expect(@list.todos[1].to_s).to match('Second item')
      expect(@list.todos[2].to_s).to match('Third item')
      expect(@list.todos[3].to_s).to match('x First done item')

      expect(@list.todos[0].line).to eql 1
      expect(@list.todos[1].line).to eql 2
      expect(@list.todos[2].line).to eql 3
      expect(@list.todos[3].line).to eql 4
    end

    it 'adds a new item' do
      @list.add 'Fourth item'
      expect(@list.todos[4].to_s).to match('Fourth item')
      expect(@list.todos[4].line).to eql 5
    end

    it 'removes an item' do
      @list.remove 1
      expect(@list.todos[0].to_s).to match('Second item')
    end

    it 'finds item by line' do
      todo = @list.find_by_line 3
      expect(todo.to_s).to match('Third item')
    end

    it 'filters list when searching' do
      @list.filter 'First'
      expect(@list.todos.count).to eql 1
    end

    it 'filters list when searching case-sensitive' do
      @list.filter 'first'
      expect(@list.todos.count).to eql 1
    end

    it 'fetches items for a certain date' do
      @list.add '2012-12-12 item'
      date = DateTime.parse('2012-12-12')
      expect(@list.on_date(date).count).to eql 1
      expect(@list.on_date(date)).to match([@list.todos.last])
    end

    it 'fetchs items before a cereain date' do
      @list.add '2012-11-11 item'
      @list.add '2012-12-12 item'
      date = DateTime.parse('2012-12-12')
      expect(@list.before_date(date).count).to eql 1
    end

    it 'includes done items in search when told to do so' do
      @list.filter 'first', with_done: true
      expect(@list.todos.count).to eql 2
    end

    it 'only includes done items in search when told to do so' do
      @list.filter 'first', only_done: true
      expect(@list.todos.count).to eql 1
    end

    it 'renders plain text' do
      comparison_string = <<EOF
First item
Second item
Third item
x First done item
EOF
      expect(@list.to_txt).to match(comparison_string.strip)
    end
  end

  describe 'with complex list' do
    before :each do
      @file = Todotxt::TodoFile.new File.join(File.dirname(__FILE__), 'fixtures', 'complex_todo.txt')
      @list = Todotxt::TodoList.new @file
    end

    it 'sorts itself automatically on parse' do
      expect(@list.todos[0].to_s).to match('(A) an item')
      expect(@list.todos[0].line).to eql(3)
    end

    it 're-sorts itself after adding a new item' do
      @list.add '(B) A new item'

      expect(@list.todos[1].to_s).to match('(B) A new item')
      expect(@list.todos[1].line).to eql(4)
    end

    it 'lists all projects and contexts in the list' do
      expect(@list.projects).to contain_exactly('+project1', '+project2')
      expect(@list.contexts).to contain_exactly('@context1', '@context2')
    end
  end

  describe 'with line-number provided' do
    it 'starts counting at the number' do
      @file = Todotxt::TodoFile.new File.join(File.dirname(__FILE__), 'fixtures', 'simple_todo.txt')
      @list = Todotxt::TodoList.new @file, 42
      expect(@list.todos[0].line).to eql 43
    end
  end
end
