# Note: This is a one-for-one translation of `ext/linenoise.h`.
@[Link(ldflags: "#{__DIR__}/linenoise.o")]
lib LibLinenoise
  alias Char = LibC::Char
  alias Int = LibC::Int
  alias SizeT = LibC::SizeT

  $linenoiseEditMore : Char*

  # The State structure represents the state during line editing.
  # We pass this state to functions implementing specific editing
  # functionalities.
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

  struct Completions
    len : SizeT
    cvec : Char**
  end

  # Non blocking API.
  fun edit_start = linenoiseEditStart(state : State*, stdin_fd : Int, stdout_fd : Int, buf : Char*, buflen : SizeT, prompt : Char*) : Int
  fun edit_feed = linenoiseEditFeed(state : State*) : Char*
  fun edit_stop = linenoiseEditStop(state : State*)
  fun hide = linenoiseHide(state : State*)
  fun show = linenoiseShow(state : State*)

  # Blocking API.
  # Note: Max line size is set to 4096 characters.
  fun prompt = linenoise(prompt : Char*) : Char*
  fun free = linenoiseFree(ptr : Void*)

  # Completion API.
  alias CompletionCallback = (Char*, Completions*) -> Void
  alias HintsCallback = (Char*, Int*, Int*) -> Char*
  alias FreeHintsCallback = (Void*) -> Void
  fun set_completion_callback = linenoiseSetCompletionCallback(callback : CompletionCallback*)
  fun set_hints_callback = linenoiseSetHintsCallback(callback : HintsCallback*)
  fun set_free_hints_callback = linenoiseSetFreeHintsCallback(callback : FreeHintsCallback*)
  fun add_completion = linenoiseAddCompletion(completions_state : Completions*, completion : Char*)

  # History API.
  fun history_add = linenoiseHistoryAdd(line : Char*) : Int
  # Note: The default max history length is 100 lines.
  fun history_set_max_len = linenoiseHistorySetMaxLen(len : Int) : Int
  fun history_save = linenoiseHistorySave(filename : Char*) : Int
  fun history_load = linenoiseHistoryLoad(filename : Char*) : Int

  # Other utilities.
  fun clear_screen = linenoiseClearScreen
  fun set_multiline = linenoiseSetMultiLine(ml : Int)
  fun print_key_codes = linenoisePrintKeyCodes
  fun mask_mode_enable = linenoiseMaskModeEnable
  fun mask_mode_disable = linenoiseMaskModeDisable
end
