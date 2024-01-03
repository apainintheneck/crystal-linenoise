require "colorize"

require "./lib_linenoise"

module Linenoise
  VERSION = "0.1.0"

  def self.reset
    @@state = nil
    @@completions.try &.clear
    @@hints.try &.clear
  end

  # Blocking API.

  def self.prompt(prompt : String) : String
    String.new(LibLinenoise.prompt(prompt))
  end

  # Non blocking API.

  private def self.state : LibLinenoise::State
    @@state ||= LibLinenoise::State.new
  end

  private def self.buffer : UInt8*
    @@buffer ||= uninitialized UInt8[1024]
  end

  def self.start_edit(prompt : String) : Int
    LibLinenoise.edit_start(
      state: pointerof(state),
      stdin_fd: -1,
      stdout_fd: -1,
      buf: pointerof(buffer),
      buflen: buffer.size,
      prompt: prompt
    )
  end

  def self.feed_edit
    String.new(LibLinenoise.edit_feed(pointerof(state)))
  end

  def self.stop_edit
    LibLinenoise.edit_stop(pointerof(state))
  end

  def self.hide
    LibLinenoise.hide(pointerof(state))
  end

  def self.show
    LibLinenoise.show(pointerof(state))
  end

  # Completion API.

  private def self.completions : Array(String)
    @@completions ||= Array(String).new
  end

  def self.add_completions(completions : Array(String))
    return if completions.empty?

    @@completions = completions.sort

    callback = ->(raw_line : Pointer(UInt8), completion_state : Pointer(LibLinenoise::Completions)) do
      each_completion(String.new(raw_line)) do |completion|
        LibLinenoise.add_completion(completion_state, completion)
      end
    end

    LibLinenoise.set_completion_callback(pointerof(callback))
  end

  private def self.each_completion(line : String, &)
    index = completions.bsearch_index { |string| string >= line }
    return if index.nil?

    while index < completions.size
      break unless completions[index].starts_with?(line)

      yield completions[index]
      index += 1
    end
  end

  # History API.

  struct Hint
    getter text : String
    getter color : Colorize::ColorANSI
    getter bold : Bool

    def initialize(@text, @color = Colorize::ColorANSI::LightGray, @bold = false)
    end
  end

  private def self.hints
    @@hints ||= Hash(String, Hint).new
  end

  def self.add_hints(hints : Hash(String, Hint))
    return if hints.empty?

    @@hints = hints

    hints_callback = ->(line : Pointer(UInt8), color : Pointer(Int32), bold : Pointer(Int32)) : Pointer(UInt8) do
      hint = self.hints[String.new(line)]?
      return Pointer(UInt8).null if hint.nil?

      color.value = hint.color.to_i
      bold.value = hint.bold ? 1 : 0
      return hint.text.to_unsafe
    end

    LibLinenoise.set_hints_callback(pointerof(hints_callback))

    free_hints_callback = ->(hint : Pointer(Void)) do
      LibLinenoise.free(hint)
    end

    LibLinenoise.set_free_hints_callback(pointerof(free_hints_callback))
  end

  # History API.

  def self.add_history(line : String) : Bool
    LibLinenoise.history_add(Line) != 0
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
      LibLinenoise.linenoiseMaskModeEnable
    else
      LibLinenoise.linenoiseMaskModeDisable
    end
  end
end
