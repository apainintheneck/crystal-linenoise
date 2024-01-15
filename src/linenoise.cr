require "./lib/lib_linenoise"
require "./linenoise/completions"

module Linenoise
  VERSION = "0.1.0"

  #
  # Blocking API.
  #

  # Prompts the user for a new line of input.
  def self.prompt(prompt : String) : String?
    line = LibLinenoise.prompt(prompt)
    return if line.null?

    String.new(line)
  end

  #
  # Completion API.
  #
  # Info: Register tab completions for the prompt command.
  #

  # Callback for setting completions based on user input.
  #
  # - In:  `Pointer(UInt8)`                     The current line as a cstring.
  # - In:  `Pointer(LibLinenoise::Completions)` The completion state to be passed to `#add_completion`.
  # - Out: `Nil`                                No return value.
  alias CompletionCallback = Proc(Pointer(UInt8), Pointer(LibLinenoise::Completions), Nil)

  # Note: The completion callback cannot be a closure since it will end up
  #       being passed to the C library internally and that is a compiler error.
  def self.set_completion_callback(callback : CompletionCallback)
    LibLinenoise.set_completion_callback(callback)
  end

  # This method should only be called inside the completion callback to register
  # valid completions.
  def self.add_completion(completion_state : Pointer(LibLinenoise::Completions), completion : String)
    LibLinenoise.add_completion(completion_state, completion)
  end

  #
  # Hints API.
  #
  # Info: Register hints that show up as the user types. These usually show up as light colored
  #       text that appears to the right of the cursor based on user input.
  #

  # Callback for registering hints based on user input.
  #
  # - In:    `Pointer(UInt8)` The current line as a cstring.
  # - Inout: `Pointer(Int32)` The ANSI color code as an integer pointer.
  # - Inout: `Pointer(Int32)` The ANSI Select Graphic Rendition (SGR) code as an integer pointer.
  # - Out:   `Pointer(UInt8)` Return the hint as a cstring (`String#to_unsafe`).
  alias HintsCallback = Proc(Pointer(UInt8), Pointer(Int32), Pointer(Int32), Pointer(UInt8))

  # Note: The hints callback cannot be a closure since it will end up
  #       being passed to the C library internally and that is a compiler error.
  def self.set_hints_callback(callback : HintsCallback)
    LibLinenoise.set_hints_callback(callback)
  end

  #
  # History API.
  #
  # Info: The command line history shows up when the user presses the up or down
  #       arrow keys to view previous commands.
  #

  # Register the most recent line to the history. It will be the first option
  # when the user presses the up arrow key.
  def self.add_history(line : String) : Bool
    LibLinenoise.history_add(line) != 0
  end

  # Change the maximum number of lines in the history.
  def self.max_history(length : Int) : Bool
    LibLinenoise.history_set_max_len(length) != 0
  end

  # Write the current history to a file.
  def self.save_history(filename : String) : Bool
    LibLinenoise.history_save(filename) != 0
  end

  # Load the history from a file.
  def self.load_history(filename : String) : Bool
    LibLinenoise.history_load(filename) != 0
  end

  #
  # Other utilities.
  #

  # Clears the entire screen and sets the cursor to the top left corner.
  def self.clear_screen
    LibLinenoise.clear_screen
  end

  # Single line mode: Scrolls to the right if input text becomes wider than the current window.
  # Mutiline mode:    Wraps the input text if it becomes wider than the current window.
  #
  # Defaults to single line mode.
  def self.set_multiline(multiline : Bool)
    LibLinenoise.set_multiline(
      multiline ? 1 : 0
    )
  end

  # Only used for debugging. It is used in the `example.cr` program.
  def self.print_key_codes
    LibLinenoise.print_key_codes
  end

  # Set text input masking. This prevents the user's keyboard input from
  # being echoed automatically to the screen. Instead, the characters all
  # get converted to asterisks (*). This is useful when users are entering
  # passwords for example.
  #
  # By default mask mode is disabled.
  def self.set_mask_mode(mask_mode : Bool)
    if mask_mode
      LibLinenoise.mask_mode_enable
    else
      LibLinenoise.mask_mode_disable
    end
  end
end
