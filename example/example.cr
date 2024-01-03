require "option_parser"

require "../src/linenoise"

async = false

OptionParser.parse do |parser|
  parser.banner = "Usage: ./example [option...]"
  parser.on("--keycodes", "Print out keycodes for debugging") do
    Linenoise.print_key_codes
  end
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

HISTORY_FILE = "#{__DIR__}/example_history.txt"

Linenoise.add_completions(["hello", "hello there"], with_hints: true)
Linenoise.add_hints({ "hello there" => Linenoise::Hint.new(text: " cruel world!", color: Colorize::ColorANSI::Red)})
Linenoise.load_history(HISTORY_FILE)

loop do
  line = Linenoise.prompt("hello> ")
  break if line.nil?

  args = line.split

  case args.first?
  when nil
    next
  when ":historylen"
    len = args[1]?.try &.to_i?

    if len.nil? || len < 0
      puts "Error: Invalid length: #{args[2]?}"
    else
      Linenoise.max_history(len)
    end
  when ":singleline"
    Linenoise.set_multiline(false)
  when ":multiline"
    Linenoise.set_multiline(true)
  when ":mask"
    Linenoise.set_mask_mode(true)
  when ":unmask"
    Linenoise.set_mask_mode(false)
  when ":clear"
    Linenoise.clear_screen
  when ":exit", ":quit"
    break
  else
    puts "echo: #{line}"
    Linenoise.add_history(line)
    Linenoise.save_history(HISTORY_FILE)
  end
end
