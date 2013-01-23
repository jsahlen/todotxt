require "thor"
require "rainbow"
require "parseconfig"

module Todotxt
  class CLI < Thor
    include Thor::Actions
    include Todotxt::CLIHelpers

    def self.source_root
      File.join File.dirname(__FILE__), "..", "..", "conf"
    end

    def initialize(*args)
      super
      @config = Config.new
      ask_and_create_conf unless @config.file_exists?
    end

    class_option :file, :type => :string, :desc => "Use a different file than todo.txt
     E.g. use 'done' to have the action performed on the file you set for 'done' in the todotxt
     configuration under [files]."

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

    desc "listproj | lsproj", "List all projects"
    def listproj
      @list.projects.each { |p| say p }
    end
    map "lsproj" => :listproj

    desc "lscon | lsc", "List all contexts"
    def lscon
      @list.contexts.each { |c| say c }
    end
    map "lsc" => :lscon

    #
    # Todo management
    #

    desc "add | a TEXT", "Add a new Todo item"
    def add(str, *str2)
      string = "#{str} #{str2.join(' ')}"
      todo = @list.add string

      puts format_todo(todo)

      @list.save
    end
    map "a" => :add

    desc "do ITEM#[, ITEM#, ITEM#, ...]", "Mark ITEM# as done"
    def do line1, *lines
      lines.unshift(line1).each do |line|
        todo = @list.find_by_line line
        if todo
          todo.do
          puts format_todo(todo)

          @list.save
        else
          error "No todo found at line #{line}"
        end
      end
    end

    desc "undo | u ITEM#[, ITEM#, ITEM#, ...]", "Mark ITEM# item as not done"
    def undo line1, *lines
      lines.unshift(line1).each do |line|
        todo = @list.find_by_line line
        if todo
          todo.undo
          puts format_todo(todo)

          @list.save
        else
          error "No todo found at line #{line}"
        end
      end
    end
    map "u" => :undo

    desc "pri | p ITEM# PRIORITY", "Set priority of ITEM# to PRIORITY"
    def pri line, priority
      todo = @list.find_by_line line
      if todo
        todo.prioritize priority
        puts format_todo(todo)

        @list.save
      else
        error "No todo found at line #{line}"
      end
    end
    map "p" => :pri

    desc "dp | depri ITEM#[, ITEM#, ITEM#, ...]", "Remove priority for ITEM#"
    def dp line1, *lines
      lines.unshift(line1).each do |line|
        todo = @list.find_by_line line
        if todo
          todo.prioritize
          puts format_todo(todo)

          @list.save
        else
          error "No todo found at line #{line}"
        end
      end
    end
    map "depri" => :dp

    desc "append | app ITEM# STRING", "Append STRING to ITEM#"
    def append line, str, *str2
      string = "#{str} #{str2.join(' ')}"
      todo = @list.find_by_line line
      if todo
        todo.append string
        puts format_todo(todo)

        @list.save
      else
        error "No todo found at line #{line}"
      end
    end
    map "app" => :append

    desc "prepend | prep ITEM# STRING", "Prepend STRING to ITEM#"
    def prepend line, str, *str2
      string = "#{str} #{str2.join(' ')}"
      todo = @list.find_by_line line
      if todo
        todo.prepend string
        puts format_todo(todo)

        @list.save
      else
        error "No todo found at line #{line}"
      end
    end
    map "prep" => :prepend

    desc "replace ITEM# TEXT", "Completely replace ITEM# text with TEXT"
    def replace line, str, *str2
      string = "#{str} #{str2.join(' ')}"
      todo = @list.find_by_line line
      if todo
        todo.replace string
        puts format_todo(todo)

        @list.save
      else
        error "No todo found at line #{line}"
      end
    end

    desc "del | rm ITEM#[, ITEM#, ITEM#, ...]", "Remove ITEM#"
    method_option :force, :type => :boolean, :aliases => "-f", :desc => "Don't confirm removal"
    def del line1, *lines
      lines.unshift(line1).each do |line|
        todo = @list.find_by_line line
        if todo
          say format_todo(todo)
          if options[:force] || yes?("Remove this item? [y/N]")
            @list.remove line
            notice "Removed from list"

            @list.save
          end
        else
          error "No todo found at line #{line}"
        end
      end
    end
    map "rm" => :del

    desc "move | mv ITEM#[, ITEM#, ITEM#, ...] file", "Move ITEM# to another file"
    def move line1, *lines, other_list_alias
      if @files[other_list_alias.to_sym].nil?
        error_and_exit "File alias #{other_list_alias} not found"
      else
        other_list = TodoList.new @files[other_list_alias.to_sym]
      end

      lines.unshift(line1).each do |line|
        todo = @list.find_by_line line
        if todo
          @list.move other_list, line
          notice format_todo(todo) +"\n" \
                 "moved to #{otherlist}"
        else
          error "No todo found at line #{line}"
        end
      end
    end
    map "mv" => :move

    #
    # File generation
    #

    desc "generate_config", "Create a .todotxt.cfg file in your home folder, containing the path to todo.txt"
    def generate_config
      copy_file "todotxt.cfg", CFG_PATH
      puts ""
    end

    desc "generate_txt", "Create a sample todo.txt"
    def generate_txt
      copy_file "todo.txt", @file
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

    def ask_and_create_conf
      say "You need a .todotxt.cfg file in your home folder to continue (used to determine the path of your todo.txt.) Answer yes to have it generated for you (pointing to ~/todo.txt), or no to create it yourself.\n\n"
      confirm_generate = yes? "Create ~/.todotxt.cfg? [y/N]"

      if confirm_generate
        @cfg.generate!
      else
        puts ""
        exit
      end
    end

    def ask_and_create_files
      if !File.exists? @file
        puts "#{@file} doesn't exist yet. Would you like to generate a sample file?"
        confirm_generate = yes? "Create #{@file}? [y/N]"

        if confirm_generate
          generate_txt
          ## Re-parse the file for future validation and usage.
          parse_files
        else
          puts ""
          exit
        end
      end
    end

    def parse_files
      @files = {}
      @file = ""

      return if (@cfg.nil? || @cfg["files"].nil?)

      # Fill the @files from settings.
      @cfg["files"].each do |name, file|
        unless file.empty?
          @files[name.to_sym] = File.expand_path(file)
        end
      end

      # Backwards compatibility with todo_txt_path
      #   when old variable is still set, and no files=>todo 
      #   given, fallback to this old version.
      if @cfg["todo_txt_path"]
        @files[:todo] ||= @cfg["todo_txt_path"]
      end

      # Determine what file should be activated, set that in @file
      if options[:file]
        file_sym = options[:file].to_sym
        if @files.has_key? file_sym
          @file = @files[file_sym]
        end
      else
        @file = @files[:todo]
      end
    end

    def validate
      # Deprecation warning for old cfg file
      # @TODO: remove after a few releases.
      unless @cfg["todo_txt_path"].nil?
        warn "DEPRECATION: you are using deprecated todo_txt_path setting in ~/.todotxt.cfg\n" \
             "Please change this to use\n" \
             "  [files]\n" \
             "  todo  = ~/path/to/todo.txt\n"
      end

      # Determine if todo, the only required todo file is configured
      unless @files.has_key? :todo
        error_and_exit  "Couldn't find 'todo' path setting in ~/.todotxt.cfg.\n" \
                        "  Please run the following to create a new configuration file:\n" \
                        "  todotxt generate_config" \
      end
    end
  end
end
