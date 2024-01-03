require "option_parser"

require "../src/linenoise"

async = false

OptionParser.parse do |parser|
  parser.banner = "Usage: ./example [option...]"
  parser.on("--multiline", "Enable multiline editing mode") do
    Linenoise.set_multiline(true)
  end
  parser.on("--keycodes", "Print out keycodes for debugging") do
    Linenoise.print_key_codes
  end
  parser.on("--async", "Enable async mode") do
    async = true
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

Linenoise.add_completions(["hello", "hello there"])
Linenoise.add_hints({ "hello" => Linenoise::Hint.new(text: " World", color: Colorize::ColorANSI::Red)})
