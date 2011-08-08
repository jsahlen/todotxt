require "thor"
require "rainbow"

module Todotxt
  class CLI < Thor
    include Thor::Actions
    include Todotxt::CLIHelpers

    @@list = TodoList.new

    desc "list | ls [SEARCH]", "List all todos, or todos matching SEARCH"
    def list search=""
      @@list.filter(search)

      render_list
    end
    map "ls" => :list

    desc "add | a TEXT", "Add a new Todo item"
    def add(str, *str2)
      str = "#{str} #{str2.join(' ')}"
      todo = @@list.add str

      puts format_todo(todo)
    end
    map "a" => :add

    desc "list_projects | lsp", "List all projects"
    def list_projects
      @@list.projects.each { |p| say p.color(:green) }
    end
    map "lsp" => :list_projects

    desc "list_contexts | lsc", "List all contexts"
    def list_contexts
      @@list.contexts.each { |c| say c.color(:cyan) }
    end
    map "lsc" => :list_contexts

    desc "version", "Show todotxt version"
    def version
      say "todotxt #{VERSION}"
    end

    private

    def render_list
      numsize = @@list.count + 1
      numsize = numsize.to_s.length + 0

      @@list.each do |t|
        say format_todo(t, numsize)
      end
    end
  end
end
