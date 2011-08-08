module Todotxt
  module CLIHelpers

    def format_todo(todo, number_padding=nil)
      line = todo.line.to_s
      
      if number_padding
        line = line.rjust number_padding
      end

      text = todo.to_s

      unless todo.done
        text.gsub! PRIORITY_REGEX do |p|
          case p[1]
          when "A"
            color = :red
          when "B"
            color = :blue
          when "C"
            color = :green
          else
            color = :white
          end

          p.to_s.color(color).bright
        end

        text.gsub! PROJECT_REGEX, '\1'.color(:green)
        text.gsub! CONTEXT_REGEX, '\1'.color(:cyan)
      else
        text = text.color(:black)
      end

      ret = ""

      ret << "#{line} ".color(:black)
      ret << "#{text}"
    end

  end
end
