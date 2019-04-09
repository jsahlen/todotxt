module Todotxt
  module CLIHelpers
    def format_todo(todo, number_padding = nil)
      line = todo.line.to_s
      line = line.rjust number_padding if number_padding

      text = todo.to_s

      if todo.done
        text = text.color(:black).bright
      else
        text.gsub! PRIORITY_REGEX do |p|
          color = case p[1]
                  when 'A'
                    :red
                  when 'B'
                    :yellow
                  when 'C'
                    :green
                  else
                    :white
                  end

          p.to_s.color(color)
        end

        text.gsub! PROJECT_REGEX, '\1'.color(:green)
        text.gsub! CONTEXT_REGEX, '\1'.color(:blue)
      end

      ret = ''

      ret << "#{line}. ".color(:black).bright
      ret << text.to_s
    end

    def warn(message = '')
      puts "WARN: #{message}".color(:yellow)
    end

    def notice(message = '')
      puts "=> #{message}".color(:green)
    end

    def error(message = '')
      puts "ERROR: #{message}".color(:red)
    end

    def error_and_exit(message = '')
      error message
      exit
    end
  end
end
