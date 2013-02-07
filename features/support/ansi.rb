require "rainbow"

Before('@ansi') do
  ENV["FORCE_COLORS"] = "TRUE"
end
