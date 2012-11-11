require "thor"
require "rainbow"
require "chronic"
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
      # Allow testing colors, rainbow usually detects whether
      #  the output goes to a TTY, but Aruba/Cucumber is not a 
      #  TTY, so we enforce it here, based on an environment var
      Sickill::Rainbow.enabled = true if ENV["FORCE_COLORS"] == "TRUE"
      @config = Config.new
      @list   = nil
      unless ["help", "generate_config", "generate_txt"].include? ARGV[0]
        ask_and_create @config unless @config.file_exists?
        if @config.deprecated? and options[:file]
          error_and_exit "You are using an old config, which has no support for mulitple files. Please update your configuration."
        end

        parse_conf
        ask_and_create @file unless @file.exists?
        @list = TodoList.new @file
      end

        @list = TodoList.new @txt_path
      end
    end

    class_option :file, :type => :string, :desc => "Use a different file than todo.txt
     E.g. use 'done' to have the action performed on the file you set for 'done' in the todotxt
     configuration under [files]."

    default_task :list

    #
    # Listing
    #

    desc "list | ls [SEARCH]", "List all todos, or todos matching SEARCH"
    method_option :done,   :type => :boolean, :aliases => "-d", :desc => "Include todo items that have been marked as done"
    method_option :simple, :type => :boolean, :desc => "Simple output (for scripts, etc)"
    def list search=""
      @list.filter(search, :with_done => (options[:done] ? true : false))
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

    desc "due", "List due items"
    def due
      if ENV["date"] # Allow testing to "freeze" the date
        today = DateTime.parse(ENV["date"]).to_date
      else
        today = DateTime.now.to_date
      end

      puts "Due today (#{today.strftime("%Y-%m-%d")})".bright
      @list.on_date(today).each { |todo| puts format_todo(todo) }
      puts "\nPast-due items".bright
      @list.before_date(today).each { |todo| puts format_todo(todo) }
      puts "\nDue 7 days in advance".bright
      ((today+1)..(today+7)).each do |day|
        @list.on_date(day).each { |todo| puts format_todo(todo) }
      end
    end

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

    desc "edit", "Open todo.txt file in your default editor"
    def edit
      system "#{@editor} #{@file.path}"
    end

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
          say format_todo(todo)
          @list.move line, other_list
          notice "Moved to #{other_list}"

          other_list.save
          @list.save
        else
          error "No todo found at line #{line}"
        end
      end
    end
    map "mv" => :move

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
          say format_todo(todo)
          @list.move line, other_list
          notice "Moved to #{other_list}"

          other_list.save
          @list.save
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
      copy_file "todotxt.cfg", Config.config_path
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

    # File should respond_to "basename", "path" and "generate!"
    def ask_and_create file
      puts "#{file.basename} doesn't exist yet. Would you like to generate a sample file?"
      confirm_generate = yes? "Create #{file.path}? [y/N]"

      if confirm_generate
        file.generate!
      else
        puts ""
        exit
      end
    end

    def parse_conf
      @files = {}

      return if @config.nil?

      # Backwards compatibility with todo_txt_path
      #   when old variable is still set, and no files=>todo 
      #   given, fallback to this old version.
      if @config["todo_txt_path"]
        @files[:todo] ||= TodoFile.new(@config["todo_txt_path"])
      else
        # Fill the @files from settings.
        @config["files"].each do |name, file_path|
          unless file_path.empty?
            @files[name.to_sym] = TodoFile.new(file_path)
          end
        end
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

      # Determine the editor
      @editor = @config["editor"] || ENV["EDITOR"]
    end
  end
end
