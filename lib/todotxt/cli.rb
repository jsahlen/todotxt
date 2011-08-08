require "thor"
require "rainbow"

require "pp"

module Todotxt
  CFG_PATH = File.expand_path("~/.todotxt.fg")

  class CLI < Thor
    include Thor::Actions
    include Todotxt::CLIHelpers

    def initialize(*args)
      super

      parse_config

      @list = TodoList.new
    end

    desc "list | ls [SEARCH]", "List all todos, or todos matching SEARCH"
    def list search=""
      puts @hello
      @list.filter(search)

      render_list
    end
    map "ls" => :list

    desc "add | a TEXT", "Add a new Todo item"
    def add(str, *str2)
      str = "#{str} #{str2.join(' ')}"
      todo = @list.add str

      puts format_todo(todo)
    end
    map "a" => :add

    desc "list_projects | lsp", "List all projects"
    def list_projects
      @list.projects.each { |p| say p.color(:green) }
    end
    map "lsp" => :list_projects

    desc "list_contexts | lsc", "List all contexts"
    def list_contexts
      @list.contexts.each { |c| say c.color(:cyan) }
    end
    map "lsc" => :list_contexts

    desc "generate_config", "Create a .todotxt.cfg file in your home folder, containing the path to todo.txt"
    def generate_config
      say "You need a .todotxt.cfg file in your home folder to continue (used to determine the path of your todo.txt.) Answer yes to have it generated for you (pointing to ~/todo.txt), or no to create it yourself."
      confirm_generate = yes? "=> ".color(:green) + "Create ~/.todotxt.cfg? [y/N]"

      if confirm_generate
        puts "yes"
      else
        puts "no"
      end
    end

    desc "version", "Show todotxt version"
    def version
      say "todotxt #{VERSION}"
    end

    private

    def render_list
      numsize = @list.count + 1
      numsize = numsize.to_s.length + 0

      @list.each do |t|
        say format_todo(t, numsize)
      end
    end

    def parse_config
      unless File.exist? CFG_PATH
        generate_config
        exit
      end
    end
  end
end
