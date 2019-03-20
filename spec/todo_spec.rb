require 'spec_helper'
require 'todotxt/todo'

describe Todotxt::Todo do
  it 'creates a todo item string' do
    todo = Todotxt::Todo.new 'an item'
    expect(todo.to_s).to match('an item')
  end

  it 'parses metadata when creating a simple item' do
    todo = Todotxt::Todo.new 'x an item +project1 +project2 @context1 @context2'
    expect(todo.to_s).to match('x an item +project1 +project2 @context1 @context2')
    expect(todo.priority).to be_nil
    expect(todo.projects).to contain_exactly('+project1', '+project2')
    expect(todo.contexts).to contain_exactly('@context1', '@context2')
    expect(todo.done).to be_truthy
  end

  it 'parses metadata when creating an item with priority' do
    todo = Todotxt::Todo.new '(A) x an item +project1 +project2 @context1 @context2'
    expect(todo.to_s).to match('(A) x an item +project1 +project2 @context1 @context2')
    expect(todo.priority).to match('A')
    expect(todo.projects).to contain_exactly('+project1', '+project2')
    expect(todo.contexts).to contain_exactly('@context1', '@context2')
    expect(todo.done).to be_truthy
  end

  it 'parses a due date' do
    todo = Todotxt::Todo.new '(A) x 2012-12-12 an item +project1 +project2 @context1 @context2'
    expect(todo.due).to eql(Chronic.parse('12 December 2012').to_date)

    todo = Todotxt::Todo.new '2012-1-2 an item +project1 +project2 @context1 @context2'
    expect(todo.due).to eql(Chronic.parse('2 January 2012').to_date)

    todo = Todotxt::Todo.new '42 folders'
    expect(todo.due).to be_nil
  end

  it 'stores line number when creating an item' do
    todo = Todotxt::Todo.new 'an item', '2'
    expect(todo.line).to match('2')
  end

  it 'sets an item as done' do
    todo = Todotxt::Todo.new 'an item'
    todo.do

    expect(todo.to_s).to match 'x an item'
    expect(todo.done).to be_truthy
  end

  it 'sets an item as not done' do
    todo = Todotxt::Todo.new 'x an item'

    todo.undo

    expect(todo.to_s).to match('an item')
    expect(todo.done).to be_falsy
  end

  it 'adds priority to an item' do
    todo = Todotxt::Todo.new 'an item'
    todo.prioritize 'a'

    expect(todo.to_s).to match('(A) an item')
    expect(todo.priority).to match('A')
  end

  it 'changes priority of an item' do
    todo = Todotxt::Todo.new '(A) an item'
    todo.prioritize 'z'

    expect(todo.to_s).to match('(Z) an item')
    expect(todo.priority).to match('Z')
  end

  it 'removes priority from an item' do
    todo = Todotxt::Todo.new '(A) an item'
    todo.prioritize

    expect(todo.to_s).to match('an item')
    expect(todo.priority).to be_nil
  end

  it 'appends text to an item' do
    todo = Todotxt::Todo.new 'an item'
    todo.append 'more text'

    expect(todo.to_s).to match('an item more text')
  end

  it 'prepends text to an item' do
    todo = Todotxt::Todo.new 'an item'
    todo.prepend 'more text'

    expect(todo.to_s).to match('more text an item')
  end

  it 'preserves priority when prepending text to an item' do
    todo = Todotxt::Todo.new '(A) an item'
    todo.prepend 'more text'

    expect(todo.to_s).to match('(A) more text an item')
    expect(todo.priority).to match('A')
  end

  it 'replaces an item with new text' do
    todo = Todotxt::Todo.new 'an item'
    todo.replace '(A) a replacement item'

    expect(todo.to_s).to match('(A) a replacement item')
    expect(todo.priority).to match('A')
  end

  it 'sorts based on line number' do
    todo1 = Todotxt::Todo.new 'an item 1', 1
    todo2 = Todotxt::Todo.new 'an item 2', 2

    expect(todo1 <=> todo2).to eql -1
  end

  it 'values items with priority higher when sorting' do
    todo1 = Todotxt::Todo.new 'an item 1', 1
    todo2 = Todotxt::Todo.new '(A) an item 2', 2

    expect(todo1 <=> todo2).to eql 1
  end
end
