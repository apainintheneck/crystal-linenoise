# An example of how the `Linenoise::Completion` module can be used.

require "../src/linenoise"

Linenoise::Completion.add(["hello", "hello there"])
Linenoise::Completion.add("howdy")
Linenoise::Completion.enable_hints!

loop do
  line = Linenoise.prompt("> ").try &.strip
  break if line.nil?

  case line
  when ":prefer_shorter_matches"
    Linenoise::Completion.prefer_shorter_matches!
    puts
  when ":exit", ":quit"
    puts "Bye!"
    break
  else
    puts line
  end
end
