require "./lib/lib_linenoise"
require "./linenoise/completions"
require "./linenoise/hints"

module Linenoise
  VERSION = "0.1.0"

  # Blocking API.
  def self.prompt(prompt : String) : String | Nil
    line = LibLinenoise.prompt(prompt)
    return if line.null?

    String.new(line)
  end

  # Completion API.
  alias CompletionCallback = Proc(
    Pointer(UInt8),                     # In:  The current line as a cstring.
    Pointer(LibLinenoise::Completions), # In:  The completion state to be passed to `#add_completion`.
    Nil                                 # Out: No return value.
  )

  def self.set_completion_callback(callback : CompletionCallback)
    LibLinenoise.set_completion_callback(callback)
  end

  def self.add_completion(completion_state : Pointer(LibLinenoise::Completions), completion : String)
    LibLinenoise.add_completion(completion_state, completion)
  end

  # Hints API.
  alias HintsCallback = Proc(
    Pointer(UInt8), # In:    The current line as a cstring.
    Pointer(Int32), # Inout: The ANSI color code as an integer pointer.
    Pointer(Int32), # Inout: The ANSI Select Graphic Rendition (SGR) code as an integer pointer.
    Pointer(UInt8)  # Out:   Return the hint as a cstring (String#to_unsafe).
  )

  def self.set_hints_callback(callback : HintsCallback)
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
