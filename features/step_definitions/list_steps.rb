Then /^I should see all entries from the todofile with numbers$/ do
  contents = ""
  File.open(File.join(ENV["HOME"], "todo.txt")).each_line do |line|
    # matching "1. Do Something"
    contents += "([\\d]\.\\s+)#{Regexp.escape(line.strip)}.*"
  end
  step "it should pass with regex:", contents
end

Then /^I should see all entries from the todofile without formatting$/ do
  contents = ""
  File.open(File.join(ENV["HOME"], "todo.txt")).each_line do |line|
    # matching "1 Do something", note the missing dot .
    contents += "([\\d]\\s+)#{Regexp.escape(line.strip)}.*"
  end
  step "it should pass with regex:", contents
  step "the output should not match /TODO: [\d]+ items/"
end
