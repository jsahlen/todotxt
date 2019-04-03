require 'todotxt/todo'

module Todotxt
  # Represent a collection of `Todo` items
  # TODO merge with TodoFile, both overlap too much
  class TodoList
    include Enumerable

    attr_reader :todos

    # @INK: refactor TodoList and TodoFile
    #   So that TodoFile contains all IO ad List is no longer dependent on file.
    #   That way, todolist lsa|listall can use multiple TodoFiles to generate one TodoList

    def initialize(file, line = nil)
      @line  = line || 0
      @todos = []
      @file  = file

      File.open(file.path).read.each_line do |l|
        add l.strip unless l.empty?
      end
    end

    # @param [String] str add the given todo string definition to the list
    # TODO also support `Todo` object
    def add(str)
      todo = Todo.new str, (@line += 1)
      @todos.push todo
      @todos.sort!

      todo
    end

    # @param [Todo|String] line remove the given todo to the list
    def remove(line)
      @todos.reject! { |t| t.line.to_s == line.to_s }
    end

    def move(line, other_list)
      other_list.add find_by_line(line).to_s
      remove line
    end

    # Get all projects from todo definitions
    # @return[Array<String>]
    def projects
      map(&:projects).flatten.uniq.sort
    end

    # Get all contexts from todo definitions
    # @return[Array<String>]
    def contexts
      map(&:contexts).flatten.uniq.sort
    end

    def find_by_line(line)
      @todos.find { |t| t.line.to_s == line.to_s }
    end

    def save
      File.open(@file.path, 'w') { |f| f.write to_txt }
    end

    def each(&block)
      @todos.each &block
    end

    def filter(search = '', opts = {})
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

    def on_date(date)
      @todos.select { |t| t.due == date }
    end

    def before_date(date)
      @todos.reject { |t| t.due.nil? || t.due >= date }
    end

    def to_txt
      @todos.sort_by(&:line).map { |t| t.to_s.strip }.join("\n")
    end

    def to_s
      @file.basename
    end

    def to_a
      map { |t| ["#{t.line}. ", t.to_s] }
    end
  end
end
