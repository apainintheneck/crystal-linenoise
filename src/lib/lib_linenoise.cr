# C bindings for the Linenoise library.
# Note: This is a one-for-one translation of `ext/linenoise.h`.
@[Link(ldflags: "#{__DIR__}/linenoise.o")]
lib LibLinenoise
  alias Char = LibC::Char
  alias Int = LibC::Int
  alias SizeT = LibC::SizeT

  $linenoiseEditMore : Char*

  #
  # Non blocking API.
  #

  # The line state used by the non-blocking multiplexing API.
  struct State
    in_completion : Int
    completion_idx : SizeT
    ifd : Int
    ofd : Int
    buf : Char*
    buflen : SizeT
    prompt : Char*
    plen : SizeT
    pos : SizeT
    oldpos : SizeT
    len : SizeT
    cols : SizeT
    oldrows : SizeT
    history_index : Int
  end

  # Note: Since this is not portable (it relies on Linux) and isn't relevant for my personal use case,
  #       I have not provided a higher-level wrapper for the non-blocking API.
  fun edit_start = linenoiseEditStart(
    state : State*, stdin_fd : Int, stdout_fd : Int,
    buf : Char*, buflen : SizeT, prompt : Char*
  ) : Int
  fun edit_feed = linenoiseEditFeed(state : State*) : Char*
  fun edit_stop = linenoiseEditStop(state : State*)
  fun hide = linenoiseHide(state : State*)
  fun show = linenoiseShow(state : State*)

  #
  # Blocking API.
  #

  # Note: Max line size is set to 4096 characters.
  fun prompt = linenoise(prompt : Char*) : Char*
  # Not needed for data allocated in Crystal which will get cleaned up automatically.
  fun free = linenoiseFree(ptr : Void*)

  #
  # Completion API.
  #

  # A struct with completions information that is exposed in the `CompletionCallback`
  # and later on passed to the `#add_completion` method.
  struct Completions
    len : SizeT
    cvec : Char**
  end
  # Receives the current line and the completions state. A new completion can be added
  # to the completions state with the `#add_completion` method.
  alias CompletionCallback = (Char*, Completions*) -> Void
  fun set_completion_callback = linenoiseSetCompletionCallback(callback : CompletionCallback)
  # Designed to be called from within the `CompletionCallback`.
  fun add_completion = linenoiseAddCompletion(completions_state : Completions*, completion : Char*)

  #
  # Hint API.
  #

  # Receives the current line, the ANSI color code and the SGF code.
  # Returns the current hint or a null pointer.
  alias HintsCallback = (Char*, Int*, Int*) -> Char*
  fun set_hints_callback = linenoiseSetHintsCallback(callback : HintsCallback)
  # Receives a void pointer and returns nothing.
  # Note: This is really only needed if you use a custom allocator for hint strings so
  #       it's probably not needed for most Crystal codebases.
  alias FreeHintsCallback = (Void*) -> Void
  fun set_free_hints_callback = linenoiseSetFreeHintsCallback(callback : FreeHintsCallback)

  #
  # History API.
  #

  fun history_add = linenoiseHistoryAdd(line : Char*) : Int
  # Note: The default max history length is 100 lines.
  fun history_set_max_len = linenoiseHistorySetMaxLen(len : Int) : Int
  fun history_save = linenoiseHistorySave(filename : Char*) : Int
  fun history_load = linenoiseHistoryLoad(filename : Char*) : Int

  #
  # Other utilities.
  #

  fun clear_screen = linenoiseClearScreen

  # Defaults to single line mode (ml = 0).
  # Single line mode: Scrolls to the right if input text becomes wider than the current window.
  # Mutiline mode:    Wraps the input text if it becomes wider than the current window.
  fun set_multiline = linenoiseSetMultiLine(ml : Int)

  # Only useful for debugging key presses. See the example program.
  fun print_key_codes = linenoisePrintKeyCodes

  # Mask mode enables typing without echoing the character to the screen.
  # This is especially useful when the user is typing a password.
  # Ex. $ **********
  fun mask_mode_enable = linenoiseMaskModeEnable
  fun mask_mode_disable = linenoiseMaskModeDisable
end
