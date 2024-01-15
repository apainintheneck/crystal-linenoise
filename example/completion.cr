# An example of how the `Linenoise::Completion` module can be used.

require "../src/linenoise"

Linenoise::Completion.add(["hello", "hello there"])
Linenoise::Completion.add("hello there everyone")
Linenoise::Completion.enable_hints!

loop do
  line = Linenoise.prompt("> ").try &.strip
  break if line.nil?

  case line
  when ":exit", ":quit"
    puts "Bye!"
    break
  else
    puts line
  end
end
