module Todotxt
  class TodoList
    include Enumerable

    attr_accessor :todos

    def initialize
      @todos = []
    end

    def add str
      todo = Todo.new str, (@todos.count + 1)
      @todos.push todo
      @todos.sort!

      return todo
    end

    def projects
      map { |t| t.projects }.flatten.uniq.sort
    end

    def contexts
      map { |t| t.contexts }.flatten.uniq.sort
    end

    def each &block
      @todos.each &block
    end

    def filter search=""
      @todos.select! { |t| t.text.downcase.include?(search.downcase) }
      self
    end

    def to_a
      map { |t| ["#{t.line}. ", t.to_s] }
    end

  end
end
