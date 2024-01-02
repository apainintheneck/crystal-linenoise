require "colorize"

class Linenoise
  VERSION = "0.1.0"

  def initialize
    @state = LibLinenoise::State.new
    @buffer = uninitialized UInt8[1024]
    @completions = [] of String
    @hints = {} of String => Hint
  end

  def start_edit(prompt : String) : Int
    LibLinenoise.edit_start(
      state: @state,
      stdin_fd: -1,
      stdout_fd: -1,
      buf: @buffer,
      buflen: @buffer.size,
      prompt: prompt
    )
  end

  def feed_edit
    String.new(LibLinenoise.edit_feed(@state))
  end

  def stop_edit
    LibLinenoise.edit_stop(@state)
  end

  def hide
    LibLinenoise.hide(@state)
  end

  def show
    LibLinenoise.show(@state)
  end

  def prompt(prompt : String) : String
    String.new(LibLinenoise.prompt(prompt))
  end

  def add_completions(completions : Array(String))
    @completions = completions.sort

    LibLinenoise.set_completion_callback(->completion_callback)
  end

  private def completion_callback(raw_line : Pointer(UInt8), completion_state : Pointer(LibLinenoise::Completion))
    each_completion(String.new(raw_line)) do |completion|
      LibLinenoise.add_completion(completion_state, completion)
    end
  end

  private def each_completion(line : String, &)
    matches = [] of String
    index = @completions.bsearch { |string| string >= line }
    return if index.nil?

    while index < sorted_completions.size
      break unless sorted_completions[index].starts_with?(line)

      yield sorted_completions[index]
      index += 1
    end
  end

  struct Hint
    getter text : String
    getter color : Colorize::ColorANSI
    getter bold : Bool

    def initialize(@text, @color = Colorize::ColorANSI::LightGray, @bold = false)
    end
  end

  def add_hints(hints : Hash(String, Hint))
    @hints = hints

    LibLinenoise.set_hints_callback(->hints_callback)
    LibLinenoise.set_free_hints_callback(->free_hints_callback)
  end

  private def hints_callback(line : Pointer(UInt8), color : Pointer(Int), bold : Pointer(Int)) : Pointer(UInt8)
    hint = @hints[String.new(line)]?
    return if hint.nil?

    color.value = hint.color.to_i
    bold.value = hint.bold ? 1 : 0
    return hint.text.to_unsafe
  end

  private def free_hints_callback(line : Pointer(UInt8))
    LibLinenoise.free(line)
  end

  def add_history(line : String) : Bool
    LibLinenoise.history_add(Line) != 0
  end

  def max_history(length : Int) : Bool
    LibLinenoise.history_set_max_len(length) != 0
  end

  def save_history(filename : String) : Bool
    LibLinenoise.history_save(filename) != 0
  end

  def load_history(filename : String) : Bool
    LibLinenoise.history_load(filename) != 0
  end

  def clear_screen
    LibLinenoise.clear_screen
  end

  def set_multiline(multiline : Bool)
    LibLinenoise.linenoiseSetMultiLine(
      multiline ? 1 : 0
    )
  end

  def print_key_codes
    LibLinenoise.print_key_codes
  end

  def set_mask_mode(mask_mode : Bool)
    if mask_mode
      LibLinenoise.linenoiseMaskModeEnable
    else
      LibLinenoise.linenoiseMaskModeDisable
    end
  end
end
