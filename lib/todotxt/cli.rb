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

    #
    # Listing
    #

    desc "list | ls [SEARCH]", "List all todos, or todos matching SEARCH"
    method_option :done,   :type => :boolean, :aliases => "-d", :desc => "Include todo items that have been marked as done"
    method_option :simple, :type => :boolean, :desc => "Simple output (for scripts, etc)"
    def list search=""
      with_done = false

      with_done = true if options[:done]

      @list.filter(search, :with_done => with_done)

      render_list :simple => !!options[:simple]
    end
    map "ls" => :list

    desc "lsdone | lsd", "List all done items"
    def lsdone search=""
      @list.filter(search, :only_done => true)

      render_list
    end
    map "lsd" => :lsdone

    desc "list_projects | lsp", "List all projects"
    def list_projects
      @list.projects.each { |p| say p }
    end
    map "lsp" => :list_projects

    desc "list_contexts | lsc", "List all contexts"
    def list_contexts
      @list.contexts.each { |c| say c }
    end
    map "lsc" => :list_contexts

    #
    # Todo management
    #

    desc "add | a TEXT", "Add a new Todo item"
    def add(str, *str2)
      str = "#{str} #{str2.join(' ')}"
      todo = @list.add str

      puts format_todo(todo)

      @list.save
    end
    map "a" => :add

    desc "do | d TODO", "Mark TODO item as done"
    method_option :remove, :type => :boolean, :aliases => "--rm", :desc => "Remove from list after marking"
    def do line
      todo = @list.find_by_line line
      if todo
        todo.do
        puts format_todo(todo)

        if options[:remove]
          @list.remove line
        end

        @list.save
      else
        error "No todo found at line #{line}"
      end
    end
    map "d" => :do

    desc "undo | u TODO", "Mark TODO item as not done"
    def undo line
      todo = @list.find_by_line line
      if todo
        todo.undo
        puts format_todo(todo)

        @list.save
      else
        error "No todo found at line #{line}"
      end
    end
    map "u" => :undo

    desc "append | ap TODO STRING", "Append STRING to TODO"
    def append line, string
      todo = @list.find_by_line line
      if todo
        todo.append string
        puts format_todo(todo)

        @list.save
      else
        error "No todo found at line #{line}"
      end
    end
    map "ap" => :append

    desc "remove | rm TODO", "Remove TODO item"
    def remove line
      todo = @list.find_by_line line
      if todo
        @list.remove line
        notice "Removed from list"

        @list.save
      else
        error "No todo found at line #{line}"
      end
    end
    map "rm" => :remove

    #
    # File generation
    #

    desc "generate_config", "Create a .todotxt.cfg file in your home folder, containing the path to todo.txt"
    def generate_config
      copy_file "todotxt.cfg", CFG_PATH
      puts ""

      parse_config
    end

    desc "generate_cfg", "Create a sample todo.txt"
    def generate_txt
      copy_file "todo.txt", @txt_path
      puts ""
    end

    #
    # Extras
    #

    desc "version", "Show todotxt version"
    def version
      say "todotxt #{VERSION}"
    end

  private

    def render_list opts={}
      numsize = @list.count + 1
      numsize = numsize.to_s.length + 0

      @list.each do |t|
        if opts[:simple]
          say "#{t.line} #{t.to_s}"
        else
          say format_todo(t, numsize)
        end
      end

      unless opts[:simple]
        puts "TODO: #{@list.count} items".color(:black).bright
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
          puts "#{txt} doesn't exist yet. Would you like to generate a sample file?"
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
