# Note: This is a one-for-one translation of `ext/linenoise.h`.
@[Link(ldflags: "#{__DIR__}/linenoise.o")]
lib LibLinenoise
  alias Void = LibC::Void
  alias Char = LibC::Char
  alias Int = LibC::Int
  alias SizeT = LibC::SizeT

  $linenoiseEditMore : Char*

  # The linenoiseState structure represents the state during line editing.
  # We pass this state to functions implementing specific editing
  # functionalities.
  struct LinenoiseState
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

  struct LinenoiseCompletions
    len : SizeT
    cvec : Char**
  end

  # Non blocking API.
  fun linenoiseEditStart(l : LinenoiseState*, stdin_fd : Int, stdout_fd : Int, buf : Char*, buflen : SizeT, prompt : Char*) : Int
  fun linenoiseEditFeed(l : LinenoiseState*) : Char*
  fun linenoiseEditStop(l : LinenoiseState*)
  fun linenoiseHide(l : LinenoiseState*)
  fun linenoiseShow(l : LinenoiseState*)

  # Blocking API.
  fun linenoise(prompt : Char*) : Char*
  fun linenoiseFree(ptr : Void*)

  # Completion API.
  alias LinenoiseCompletionCallback = (Char*, LinenoiseCompletions*) -> Void
  alias LinenoiseHintsCallback = (Char*, Int*, Int*) -> Void
  alias LinenoiseFreeHintsCallback = (Void*) -> Void
  fun linenoiseSetCompletionCallback(callback : LinenoiseCompletionCallback*)
  fun linenoiseSetHintsCallback(callback : LinenoiseHintsCallback*)
  fun linenoiseSetFreeHintsCallback(callback : LinenoiseFreeHintsCallback*)
  fun linenoiseAddCompletion(completions_state : LinenoiseCompletions*, completion : Char*)

  # History API.
  fun linenoiseHistoryAdd(line : Char*) : Int
  fun linenoiseHistorySetMaxLen(len : Int) : Int
  fun linenoiseHistorySave(filename : Char*) : Int
  fun linenoiseHistoryLoad(filename : Char*) : Int

  # Other utilities.
  fun linenoiseClearScreen
  fun linenoiseSetMultiLine(ml : Int)
  fun linenoisePrintKeyCodes
  fun linenoiseMaskModeEnable
  fun linenoiseMaskModeDisable
end
