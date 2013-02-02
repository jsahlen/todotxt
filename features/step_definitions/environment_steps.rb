Given /^a default config exists$/ do
  write_file(".todotxt.cfg", "[files]\ntodo = todo.txt")
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
