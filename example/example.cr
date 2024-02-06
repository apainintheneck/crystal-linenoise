# A test example loosely based on the test program in the linenoise repo.
# It's purpose is to allow for interactive testing of the `Linenoise` module
# and it is tested by the `example_spec.expect` script when `make test` is run.

require "option_parser"

require "../src/linenoise"

HELP_TEXT = <<-HELP
[Program]
  This is used as an example and to manually test if
  the line editor is working as expected.

  The following four words are added as default completion hints.
  - ["buenas", "buenas noches", "hello", "hello there"]

  A temporary history file is created with the following lines.
  - ["first", "second", "third"]

[REPL Commands]
  :push <completion>    -- Add a new completion.
  :pop <completion>     -- Remove a completion.
  :show                 -- Show the completions list.
  :history_len <length> -- Change the history length.
  :history_dump         -- Print the current history file.
  :singleline           -- Enter single line editing mode.
  :multiline            -- Enter multiline editing mode.
  :mask                 -- Enter masked editing mode.
  :unmask               -- Exit masked editing mode.
  :clear                -- Clear screen.
  :help                 -- Show this message.
  :debug                -- Print key codes.
  :exit                 -- Exit the program.
  :quit                 -- Quit the program.
>-------------------------------------------->
HELP

module TestCompletions
  private def self.completions : Array(String)
    @@completions ||= Array(String).new
  end

  private def self.find_index(line : String) : Int32?
    self.completions.bsearch_index { |string| string >= line }
  end

  def self.push_completion(completion : String)
    index = self.find_index(completion)

    if index.nil?
      self.completions.push(completion)
    elsif self.completions[index] != completion
      self.completions.insert(index, completion)
    end
  end

  def self.pop_completion(completion : String)
    index = self.find_index(completion)

    return if index.nil?
    return if self.completions[index] != completion

    self.completions.delete_at(index)
  end

  def self.pretty_print_completions
    p self.completions
  end

  private def self.each_completion(line : String, &)
    return if line.empty?

    index = self.find_index(line)
    return if index.nil?

    while index < self.completions.size
      break unless self.completions[index].starts_with?(line)

      yield self.completions[index]
      index += 1
    end
  end

  def self.add_completions(completions : Array(String))
    return if completions.empty?

    @@completions = completions.sort

    Linenoise.set_completion_callback ->(raw_line : Pointer(UInt8), completion_state : Pointer(LibLinenoise::Completions)) do
      self.each_completion(String.new(raw_line)) do |completion|
        Linenoise.add_completion(completion_state, completion)
      end
    end

    Linenoise.set_hints_callback ->(raw_line : Pointer(UInt8), color : Pointer(Int32), bold : Pointer(Int32)) : Pointer(UInt8) do
      line = String.new(raw_line)

      self.each_completion(line) do |hint|
        next if hint == line

        color.value = Colorize::ColorANSI::DarkGray.to_i
        bold.value = 0
        return hint.byte_slice(start: line.size).to_unsafe
      end

      return Pointer(UInt8).null
    end
  end
end

TestCompletions.add_completions(["buenas", "buenas noches", "hello", "hello there"])

File.tempfile(suffix: "example_history.txt") do |history_file|
  # Add some data to the history file for testing.
  %w[first second third].each { |string| history_file.puts string }
  history_file.close

  Linenoise.load_history(history_file.path)

  puts HELP_TEXT

  loop do
    line = Linenoise.prompt("\033[01;33mhello\033[0m> ")
    break if line.nil?

    args = line.split

    case args.first?
    when nil
      next
    when ":push"
      completion = line.sub(/^\s*:push\s*/, "")

      if completion.empty?
        puts "Error: Missing completion"
      else
        TestCompletions.push_completion(completion)
      end
    when ":pop"
      completion = line.sub(/^\s*:pop\s*/, "")

      if completion.empty?
        puts "Error: Missing completion"
      else
        TestCompletions.pop_completion(completion)
      end
    when ":show"
      TestCompletions.pretty_print_completions
    when ":history_len"
      len = args[1]?.try &.to_i?

      if len.nil? || len < 0
        puts "Error: Invalid length: #{args[2]?}"
      else
        Linenoise.max_history(len)
        Linenoise.load_history(history_file.path)
      end
    when ":history_dump"
      puts File.read(history_file.path)
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
      Linenoise.save_history(history_file.path)
    end
  end
ensure
  history_file.delete
end
