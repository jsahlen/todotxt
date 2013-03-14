require "todotxt/todo"

module Todotxt
  #@TODO merge with TodoFile, both overlap too much
  class TodoList
    include Enumerable

    attr_accessor :todos

    def initialize file
      @todos = []
      @file  = file

      File.open(file.path).read.each_line do |l|
        add l.strip unless l.empty?
      end
    end

    def add str
      todo = Todo.new str, (@todos.count + 1)
      @todos.push todo
      @todos.sort!

      return todo
    end

    def remove line
      @todos.reject! { |t| t.line.to_s == line.to_s }
    end

    def move line, other_list
      other_list.add find_by_line(line).to_s
      remove line
    end

    def projects
      map { |t| t.projects }.flatten.uniq.sort
    end

    def contexts
      map { |t| t.contexts }.flatten.uniq.sort
    end

    def find_by_line line
      @todos.find { |t| t.line.to_s == line.to_s }
    end

    def save
      File.open(@file.path, "w") { |f| f.write to_txt }
    end

    def each &block
      @todos.each &block
    end

    def filter search="", opts={}
      @todos.select! do |t|
        select = false

        text = t.to_s.downcase

        if opts[:only_done]
          select = true if t.done
        else
          if opts[:with_done]
            select = true
          else
            select = true unless t.done
          end
        end

        select = false unless text.include?(search.downcase)

        select
      end

      self
    end

    def on_date date
      @todos.select { |t| t.due == date }
    end

    def before_date date
      @todos.reject { |t| t.due.nil? || t.due >= date }
    end

    def to_txt
      @todos.sort { |a,b| a.line <=> b.line }.map { |t| t.to_s.strip }.join("\n")
    end

    def to_s
      @file.basename
    end

    def to_a
      map { |t| ["#{t.line}. ", t.to_s] }
    end

  end
end
