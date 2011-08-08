module Todotxt
  class Todo

    attr_accessor :text
    attr_accessor :line
    attr_accessor :priority
    attr_accessor :projects
    attr_accessor :contexts

    def initialize text, line=nil
      @text = text
      @line = line
      @priority = text.scan(PRIORITY_REGEX).flatten.first || nil
      @projects = text.scan(PROJECT_REGEX).flatten.uniq   || []
      @contexts = text.scan(CONTEXT_REGEX).flatten.uniq   || []
    end

    def to_s
      text
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
