require 'todotxt/regex'

module Todotxt
  # Represent a task formatted according to
  # [todo.txt format rules](https://github.com/todotxt/todo.txt#todotxt-format-rules)
  #
  # @attr [String] the complete text definition of this task
  # @attr [Integer] line the line number of this task
  # @attr [Char] the character which defines the task's priority
  # @attr [Array] projects list of linked projects
  # @attr [Array] contexts list of linked contexts
  # @attr [Boolean] done `true` if task is done
  class Todo
    attr_accessor :text
    attr_accessor :line
    attr_accessor :priority
    attr_accessor :projects
    attr_accessor :contexts
    attr_accessor :done

    # @param[String] text
    def initialize(text, line = nil)
      @line = line

      create_from_text text
    end

    # Get due date if set
    # @return [Date|Nil]
    def due
      date = Chronic.parse(text.scan(DATE_REGEX).flatten[2])
      date.nil? ? nil : date.to_date
    end

    # Mark this task as done
    def do
      unless done
        @text = "x #{text}".strip
        @done = true
      end
    end

    # Mark this task as not done
    def undo
      if done
        @text = text.sub(DONE_REGEX, '').strip
        @done = false
      end
    end

    def prioritize(new_priority = nil, opts = {})
      return if new_priority && !new_priority.match(/^[A-Z]$/i)

      new_priority = new_priority.upcase if new_priority

      priority_string = new_priority ? "(#{new_priority}) " : ''

      if priority && !opts[:force]
        @text.gsub! PRIORITY_REGEX, priority_string
      else
        @text = "#{priority_string}#{text}".strip
      end

      @priority = new_priority
    end

    # Add some text to the end of this task definition
    def append(appended_text = '')
      @text << ' ' << appended_text
    end

    # Add some text to the beginning of this task definition
    def prepend(prepended_text = '')
      @text = "#{prepended_text} #{text.gsub(PRIORITY_REGEX, '')}"
      prioritize priority, force: true
    end

    def replace(text)
      create_from_text text
    end

    # @return [String]
    def to_s
      text.clone
    end

    # Compare with another `Todo` based on `line` and `priority` attributes
    # @param [Todo] b
    def <=>(b)
      return 1 unless b.is_a? Todo
      return line <=> b.line if priority.nil? && b.priority.nil?

      return 1 if priority.nil?
      return -1 if b.priority.nil?

      priority <=> b.priority
    end

    private

    def create_from_text(text)
      @text = text
      @priority = text.scan(PRIORITY_REGEX).flatten.first || nil
      @projects = text.scan(PROJECT_REGEX).flatten.uniq   || []
      @contexts = text.scan(CONTEXT_REGEX).flatten.uniq   || []
      @done = !text.scan(DONE_REGEX).empty?
    end
  end
end
