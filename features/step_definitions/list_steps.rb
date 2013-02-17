Then /^I should see all entries from the todofile with numbers$/ do
  step %{I should see all entries from the todofile named "todo.txt" with numbers}
end

Then /^I should see all entries from the todofile named "([^"]*)" with numbers$/ do |filename|
  contents = ""
  File.open(File.join(ENV["HOME"], filename)).each_line do |line|
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

Then /^it should count (\d+) TODO\-items$/ do |count|
  step %{the output should match /^TODO: #{count} items$/}
end

Then /^it should output "([^"]*)" brightly in "([^"]*)"$/ do |string, color|
  assert_partial_output(string.color(color.to_sym).bright, all_output)
end
Then /^it should output "([^"]*)" in "([^"]*)"$/ do |string, color|
  assert_partial_output(string.color(color.to_sym), all_output)
end
