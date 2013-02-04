Given /^a default config exists$/ do
  write_file(".todotxt.cfg", "[files]\ntodo = todo.txt")
end

Given /^an old config exists$/ do
  write_file(".todotxt.cfg", "todo_txt_path = todo.txt")
end

Given /^an empty environment$/ do
  step %{a file named ".todotxt.cfg" should not exist}
  step %{a file named "todo.txt" should not exist}
end

Given /^a config exists with the following files:$/ do |files|
  files_directive = "[files]\n"
  files_directive += files.hashes.map {|file| "#{file["alias"]}=#{file["path"]}" }.join("\n")
  write_file(".todotxt.cfg", files_directive)
end

Given /^a todofile exists$/ do
  write_file("todo.txt", "Read documentation for todotxt\nWrite cucumber steps for todotxt")
end

Given /^a todofile with done items exists$/ do
  write_file("todo.txt", "Read documentation for todotxt\nx Install todotxt\nWrite cucumber steps for todotxt")
end

Given /^a todofile with the following items exists:$/ do |todolist|
  contents = todolist.hashes.map {|row| row["todo"] }.join("\n")
  write_file("todo.txt", contents)
end

Given /^an empty todofile named "(.*?)" exists$/ do |filename|
  write_file(filename, "")
end

