require "option_parser"

require "../src/linenoise"

HELP_TEXT = <<-HELP
[REPL Commands]
  :historylen <length> -- Change the history length.
  :singleline          -- Enter single line editing mode.
  :multiline           -- Enter multiline editing mode.
  :mask                -- Enter masked editing mode.
  :unmask              -- Exit masked editing mode.
  :clear               -- Clear screen.
  :help                -- Show this message
  :debug               -- Print key codes.
  :exit                -- Exit the program.
  :quit                -- Quit the program.
HELP

async = false

OptionParser.parse do |parser|
  parser.banner = "Usage: crystal run example/example.cr"
  parser.on("-h", "--help", "Show this help") do
    puts parser
    puts
    puts HELP_TEXT
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

HISTORY_FILE = "#{__DIR__}/example_history.txt"

Linenoise.add_completions(["hi", "hello", "hello there"], with_hints: true)
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
      Linenoise.load_history(HISTORY_FILE)
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
  when ":help"
    puts HELP_TEXT
  when ":debug"
    Linenoise.print_key_codes
  when ":exit", ":quit"
    puts "Have a nice day!"
    break
  else
    puts "echo: #{line}"
    Linenoise.add_history(line)
    Linenoise.save_history(HISTORY_FILE)
  end
end
