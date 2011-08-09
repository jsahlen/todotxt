require "todotxt/regex"

module Todotxt
  class Todo

    attr_accessor :text
    attr_accessor :line
    attr_accessor :priority
    attr_accessor :projects
    attr_accessor :contexts
    attr_accessor :done

    def initialize text, line=nil
      @line = line

      create_from_text text
    end

    def create_from_text text
      @text = text
      @priority = text.scan(PRIORITY_REGEX).flatten.first || nil
      @projects = text.scan(PROJECT_REGEX).flatten.uniq   || []
      @contexts = text.scan(CONTEXT_REGEX).flatten.uniq   || []
      @done = !text.scan(DONE_REGEX).empty?
    end

    def do
      unless done
        @text = "x #{text}".strip
        @done = true
      end
    end

    def undo
      if done
        @text = text.sub(DONE_REGEX, "").strip
        @done = false
      end
    end

    def prioritize new_priority=nil, opts={}
      if new_priority && !new_priority.match(/^[A-Z]$/i)
        return
      end

      if new_priority
        new_priority = new_priority.upcase
      end

      priority_string = new_priority ? "(#{new_priority}) " : ""

      if priority && !opts[:force]
        @text.gsub! PRIORITY_REGEX, priority_string
      else
        @text = "#{priority_string}#{text}".strip
      end

      @priority = new_priority
    end

    def append appended_text=""
      @text << " " << appended_text
    end

    def prepend prepended_text=""
      @text = "#{prepended_text} #{text.gsub(PRIORITY_REGEX, '')}"
      prioritize priority, :force => true
    end

    def replace text
      create_from_text text
    end

    def to_s
      text.clone
    end

    def <=> b
      if priority.nil? && b.priority.nil?
        return line <=> b.line
      end

      return 1 if priority.nil?
      return -1 if b.priority.nil?

      return priority <=> b.priority
    end

  end
end
