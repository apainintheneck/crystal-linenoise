require "colorize"

require "./lib_linenoise"

module Linenoise
  VERSION = "0.1.0"

  # Blocking API.

  def self.prompt(prompt : String) : String | Nil
    line = LibLinenoise.prompt(prompt)
    return if line.null?

    String.new(line)
  end

  # Completion API.

  private def self.completions : Array(String)
    @@completions ||= Array(String).new
  end

  private def self.each_completion(line : String, &)
    return if line.empty?

    index = self.completions.bsearch_index { |string| string >= line }
    return if index.nil?

    while index < self.completions.size
      break unless self.completions[index].starts_with?(line)

      yield self.completions[index]
      index += 1
    end
  end

  def self.add_completions(completions : Array(String), with_hints = false)
    return if completions.empty?

    @@completions = completions.sort

    LibLinenoise.set_completion_callback ->(raw_line : Pointer(UInt8), completion_state : Pointer(LibLinenoise::Completions)) do
      self.each_completion(String.new(raw_line)) do |completion|
        LibLinenoise.add_completion(completion_state, completion)
      end
    end

    return unless with_hints

    LibLinenoise.set_hints_callback ->(raw_line : Pointer(UInt8), color : Pointer(Int32), bold : Pointer(Int32)) : Pointer(UInt8) do
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

  def self.set_completion_callback(callback : Proc(Pointer(UInt8), Pointer(LibLinenoise::Completions), Nil))
    LibLinenoise.set_completion_callback(callback)
  end

  # History API.

  struct Hint
    getter text : String
    getter color : Colorize::ColorANSI
    getter bold : Bool

    def initialize(@text, @color = Colorize::ColorANSI::DarkGray, @bold = false)
    end
  end

  private def self.hints
    @@hints ||= Hash(String, Hint).new
  end

  def self.add_hints(hints = Hash(String, Hint).new)
    return if hints.empty?

    @@hints = hints

    LibLinenoise.set_hints_callback ->(raw_line : Pointer(UInt8), color : Pointer(Int32), bold : Pointer(Int32)) : Pointer(UInt8) do
      line = String.new(raw_line)
      hint = self.hints[line]?
      return Pointer(UInt8).null if hint.nil?

      color.value = hint.color.to_i
      bold.value = hint.bold ? 1 : 0
      return hint.text.to_unsafe
    end
  end

  def self.set_hints_callback(callback : Proc(Pointer(UInt8), Pointer(Int32), Pointer(Int32), Pointer(UInt8)))
    LibLinenoise.set_hints_callback(callback)
  end

  # History API.

  def self.add_history(line : String) : Bool
    LibLinenoise.history_add(line) != 0
  end

  def self.max_history(length : Int) : Bool
    LibLinenoise.history_set_max_len(length) != 0
  end

  def self.save_history(filename : String) : Bool
    LibLinenoise.history_save(filename) != 0
  end

  def self.load_history(filename : String) : Bool
    LibLinenoise.history_load(filename) != 0
  end

  # Other utilities.

  def self.clear_screen
    LibLinenoise.clear_screen
  end

  def self.set_multiline(multiline : Bool)
    LibLinenoise.set_multiline(
      multiline ? 1 : 0
    )
  end

  def self.print_key_codes
    LibLinenoise.print_key_codes
  end

  def self.set_mask_mode(mask_mode : Bool)
    if mask_mode
      LibLinenoise.mask_mode_enable
    else
      LibLinenoise.mask_mode_disable
    end
  end
end
