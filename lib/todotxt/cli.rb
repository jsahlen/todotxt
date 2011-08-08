require "thor"
require "rainbow"
require "parseconfig"

module Todotxt
  CFG_PATH = File.expand_path("~/.todotxt.cfg")

  class CLI < Thor
    include Thor::Actions
    include Todotxt::CLIHelpers

    def self.source_root
      File.join File.dirname(__FILE__), "..", "..", "conf"
    end

    def initialize(*args)
      super

      unless ["help", "generate_config"].include? ARGV[0]
        parse_config

        @list = TodoList.new @txt_path
      end
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

    desc "generate_config", "Create a .todotxt.cfg file in your home folder, containing the path to todo.txt"
    def generate_config
      copy_file "todotxt.cfg", CFG_PATH

      parse_config
    end

    desc "generate_cfg", "Create a sample todo.txt"
    def generate_txt
      copy_file "todo.txt", @txt_path
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
        puts "You need a .todotxt.cfg file in your home folder to continue (used to determine the path of your todo.txt.) Answer yes to have it generated for you (pointing to ~/todo.txt), or no to create it yourself.\n\n"
        confirm_generate = yes? "Create ~/.todotxt.cfg? [y/N]"

        if confirm_generate
          generate_config
        else
          puts ""
          exit
        end
      end

      cfg = ParseConfig.new(CFG_PATH)

      txt = cfg.get_value "todo_txt_path"

      if txt
        @txt_path = File.expand_path(txt)

        unless File.exist? @txt_path
          puts "#{txt} doesn't exist yet. Would you like to genereate a sample file?"
          confirm_generate = yes? "Create #{txt}? [y/N]"

          if confirm_generate
            generate_txt
          else
            puts ""
            exit
          end
        end
      else
        error "Couldn't find todo_txt_path setting in ~/.todotxt.cfg."
        puts "Please run the following to create a new configuration file:"
        puts "    todotxt generate_config"
        exit
      end
    end
  end
end
