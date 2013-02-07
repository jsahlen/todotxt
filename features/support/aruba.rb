require 'aruba/cucumber'

# Temporarily enforce an isolated, fake, homedir.
Around do |scenario, block|
  @__aruba_original_home = ENV["HOME"]
  ENV["HOME"] = File.expand_path(File.join("tmp", "aruba"))
  block.call
  ENV["HOME"] = @__aruba_original_home
end
