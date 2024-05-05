crystal_doc_search_index_callback({"repository_name":"linenoise","body":"# linenoise\n\nCrystal bindings for the lightweight [Linenoise](https://github.com/antirez/linenoise) line editor library written in C. It is a minimal alternative to readline and libedit.\n\nLinenoise is written in C code that supports most distributions of the Linux, macOS and BSD operating systems. We compile the library on install so linking should not be a problem and the library is lightwieght (less than 1500 lines of code) so the resulting binary should be small.\n\nAs of `v0.4.0`, UTF-8 support has been added. This means that the cursor won't have problems when writing in languages with non-Latin alphabets or emoji.\n\n## Installation\n\n1. Add the dependency to your `shard.yml`:\n\n   ```yaml\n   dependencies:\n     linenoise:\n       github: apainintheneck/crystal-linenoise\n   ```\n\n2. Run `shards install`\n\n## Usage\n\n```crystal\nrequire \"linenoise\"\n\nCOMPLETIONS = [\n  ...\n]\n\n# Enable tab completions.\nLinenoise::Completion.add(COMPLETIONS)\n\n# Enable completion hints to the right of the cursor.\nLinenoise::Completion.enable_hints!\n\nHISTORY_FILE = \"...\"\n\nLinenoise.load_history(HISTORY_FILE)\n\n# A simple REPL.\nloop do\n  line = Linenoise.prompt(\"> \")\n  break if line.nil?\n\n  # Process line here.\n\n  Linenoise.add_history(line)\n  Linenoise.save_history(HISTORY_FILE)\nend\n```\n\nFor more information look at the files in the `example/` directory and the [documentation website](https://apainintheneck.github.io/crystal-linenoise/).\n\n## Example Projects\n\nThese projects use this library as a dependency and can be used as a guide when setting things up. Let me know if you'd like your project to be added to the list.\n\n- [gitsh](https://github.com/apainintheneck/gitsh) : a simple shell for `git`\n\n## Missing Features & Known Bugs\n\nThere is no high-level wrapper around the multiplexing API but the Crystal bindings have been added for it. See `src/lib/lib_linenoise.cr` for more details.\n\n## Alternatives\n\nThere are a few other line editing libraries available for Crystal.\n\n- [reply](https://github.com/I3oris/reply)\n- [fancyline](https://github.com/Papierkorb/fancyline)\n- [crystal-readline](https://github.com/crystal-lang/crystal-readline)\n\n## Development\n\nDevelopment setup is mostly managed by the Makefile.\n\nOther than that there is the Linenoise extension in `ext/` that can be built with `make extension`. Keep in mind that this also gets installed automatically in a postinstall step when this shard is included as a dependency and `shard install` is run.\n\nInteractive testing is available using the `example/example.cr` program which allows you to check on different line editing features. It can be run with `make example`. The `make specs` command runs the Crystal specs. The `make expect` command runs tests on this example program using an `expect` script so `expect` will need to be installed to run them.\n\nThe `make lint` command checks for linting errors and the `make fix` command fixes them automatically.\n\nThe `crystal docs` command can be used to build the docs locally or you can visit the [documentation website](https://apainintheneck.github.io/crystal-linenoise/) that gets generated automatically by the `.github/workflows/docs.yml` workflow.\n\n## Contributing\n\n1. Fork it (<https://github.com/apainintheneck/linenoise/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Contributors\n\n- [apainintheneck](https://github.com/apainintheneck) - creator and maintainer\n\n## Acknowledgments\n\nI have pulled in a few PRs from upstream that haven't been merged into the main Linenoise project yet.\n\nCheck out the [extension changes](ext/CHANGES.md) file for more information.\n\n## License\n\nThis library is released under the [MIT license](LICENSE).\n\nThe Linenoise library is included in this shard and uses the [BSD-2-Clause license](ext/LICENSE)\nwhich allows code to be used freely as long as the license is included in derivative works.\n","program":{"html_id":"linenoise/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"locations":[],"repository_name":"linenoise","program":true,"enum":false,"alias":false,"const":false,"types":[{"html_id":"linenoise/Linenoise","path":"Linenoise.html","kind":"module","full_name":"Linenoise","name":"Linenoise","abstract":false,"locations":[{"filename":"src/linenoise.cr","line_number":4,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L4"},{"filename":"src/linenoise/completion.cr","line_number":3,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise/completion.cr#L3"}],"repository_name":"linenoise","program":false,"enum":false,"alias":false,"const":false,"constants":[{"id":"VERSION","name":"VERSION","value":"\"0.4.0\""}],"class_methods":[{"html_id":"add_completion(completion_state:Pointer(LibLinenoise::Completions),completion:String)-class-method","name":"add_completion","doc":"This method should only be called inside the completion callback to register\nvalid completions.","summary":"<p>This method should only be called inside the completion callback to register valid completions.</p>","abstract":false,"args":[{"name":"completion_state","external_name":"completion_state","restriction":"Pointer(LibLinenoise::Completions)"},{"name":"completion","external_name":"completion","restriction":"String"}],"args_string":"(completion_state : Pointer(LibLinenoise::Completions), completion : String)","args_html":"(completion_state : Pointer(LibLinenoise::Completions), completion : String)","location":{"filename":"src/linenoise.cr","line_number":40,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L40"},"def":{"name":"add_completion","args":[{"name":"completion_state","external_name":"completion_state","restriction":"Pointer(LibLinenoise::Completions)"},{"name":"completion","external_name":"completion","restriction":"String"}],"visibility":"Public","body":"LibLinenoise.add_completion(completion_state, completion)"}},{"html_id":"add_history(line:String):Bool-class-method","name":"add_history","doc":"Register the most recent line to the history. It will be the first option\nwhen the user presses the up arrow key.","summary":"<p>Register the most recent line to the history.</p>","abstract":false,"args":[{"name":"line","external_name":"line","restriction":"String"}],"args_string":"(line : String) : Bool","args_html":"(line : String) : Bool","location":{"filename":"src/linenoise.cr","line_number":74,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L74"},"def":{"name":"add_history","args":[{"name":"line","external_name":"line","restriction":"String"}],"return_type":"Bool","visibility":"Public","body":"(LibLinenoise.history_add(line)) != 0"}},{"html_id":"clear_screen-class-method","name":"clear_screen","doc":"Clears the entire screen and sets the cursor to the top left corner.","summary":"<p>Clears the entire screen and sets the cursor to the top left corner.</p>","abstract":false,"location":{"filename":"src/linenoise.cr","line_number":98,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L98"},"def":{"name":"clear_screen","visibility":"Public","body":"LibLinenoise.clear_screen"}},{"html_id":"load_history(filename:String):Bool-class-method","name":"load_history","doc":"Load the history from a file.","summary":"<p>Load the history from a file.</p>","abstract":false,"args":[{"name":"filename","external_name":"filename","restriction":"String"}],"args_string":"(filename : String) : Bool","args_html":"(filename : String) : Bool","location":{"filename":"src/linenoise.cr","line_number":89,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L89"},"def":{"name":"load_history","args":[{"name":"filename","external_name":"filename","restriction":"String"}],"return_type":"Bool","visibility":"Public","body":"(LibLinenoise.history_load(filename)) != 0"}},{"html_id":"max_history(length:Int):Bool-class-method","name":"max_history","doc":"Change the maximum number of lines in the history.","summary":"<p>Change the maximum number of lines in the history.</p>","abstract":false,"args":[{"name":"length","external_name":"length","restriction":"Int"}],"args_string":"(length : Int) : Bool","args_html":"(length : Int) : Bool","location":{"filename":"src/linenoise.cr","line_number":79,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L79"},"def":{"name":"max_history","args":[{"name":"length","external_name":"length","restriction":"Int"}],"return_type":"Bool","visibility":"Public","body":"(LibLinenoise.history_set_max_len(length)) != 0"}},{"html_id":"print_key_codes-class-method","name":"print_key_codes","doc":"Only used for debugging. It is used in the `example.cr` program.","summary":"<p>Only used for debugging.</p>","abstract":false,"location":{"filename":"src/linenoise.cr","line_number":113,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L113"},"def":{"name":"print_key_codes","visibility":"Public","body":"LibLinenoise.print_key_codes"}},{"html_id":"prompt(prompt:String):String|Nil-class-method","name":"prompt","doc":"Prompts the user for a new line of input.","summary":"<p>Prompts the user for a new line of input.</p>","abstract":false,"args":[{"name":"prompt","external_name":"prompt","restriction":"String"}],"args_string":"(prompt : String) : String | Nil","args_html":"(prompt : String) : String | Nil","location":{"filename":"src/linenoise.cr","line_number":12,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L12"},"def":{"name":"prompt","args":[{"name":"prompt","external_name":"prompt","restriction":"String"}],"return_type":"String | ::Nil","visibility":"Public","body":"line = LibLinenoise.prompt(prompt)\nif line.null?\n  return\nend\nString.new(line)\n"}},{"html_id":"save_history(filename:String):Bool-class-method","name":"save_history","doc":"Write the current history to a file.","summary":"<p>Write the current history to a file.</p>","abstract":false,"args":[{"name":"filename","external_name":"filename","restriction":"String"}],"args_string":"(filename : String) : Bool","args_html":"(filename : String) : Bool","location":{"filename":"src/linenoise.cr","line_number":84,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L84"},"def":{"name":"save_history","args":[{"name":"filename","external_name":"filename","restriction":"String"}],"return_type":"Bool","visibility":"Public","body":"(LibLinenoise.history_save(filename)) != 0"}},{"html_id":"set_completion_callback(callback:CompletionCallback)-class-method","name":"set_completion_callback","doc":"Note: The completion callback cannot be a closure since it will end up\n      being passed to the C library internally and that is a compiler error.","summary":"<p>Note: The completion callback cannot be a closure since it will end up       being passed to the C library internally and that is a compiler error.</p>","abstract":false,"args":[{"name":"callback","external_name":"callback","restriction":"CompletionCallback"}],"args_string":"(callback : CompletionCallback)","args_html":"(callback : <a href=\"Linenoise/CompletionCallback.html\">CompletionCallback</a>)","location":{"filename":"src/linenoise.cr","line_number":34,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L34"},"def":{"name":"set_completion_callback","args":[{"name":"callback","external_name":"callback","restriction":"CompletionCallback"}],"visibility":"Public","body":"LibLinenoise.set_completion_callback(callback)"}},{"html_id":"set_encoding(encoding:Encoding)-class-method","name":"set_encoding","doc":"Set the string encoding for the linenoise session. It defaults to UTF8.","summary":"<p>Set the string encoding for the linenoise session.</p>","abstract":false,"args":[{"name":"encoding","external_name":"encoding","restriction":"Encoding"}],"args_string":"(encoding : Encoding)","args_html":"(encoding : <a href=\"Linenoise/Encoding.html\">Encoding</a>)","location":{"filename":"src/linenoise.cr","line_number":141,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L141"},"def":{"name":"set_encoding","args":[{"name":"encoding","external_name":"encoding","restriction":"Encoding"}],"visibility":"Public","body":"case encoding\nin Encoding::ASCII\n  LibLinenoise.set_encoding(LibLinenoise::ASCII)\nin Encoding::UTF8\n  LibLinenoise.set_encoding(LibLinenoise::UTF8)\nend"}},{"html_id":"set_hints_callback(callback:HintsCallback)-class-method","name":"set_hints_callback","doc":"Note: The hints callback cannot be a closure since it will end up\n      being passed to the C library internally and that is a compiler error.","summary":"<p>Note: The hints callback cannot be a closure since it will end up       being passed to the C library internally and that is a compiler error.</p>","abstract":false,"args":[{"name":"callback","external_name":"callback","restriction":"HintsCallback"}],"args_string":"(callback : HintsCallback)","args_html":"(callback : <a href=\"Linenoise/HintsCallback.html\">HintsCallback</a>)","location":{"filename":"src/linenoise.cr","line_number":61,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L61"},"def":{"name":"set_hints_callback","args":[{"name":"callback","external_name":"callback","restriction":"HintsCallback"}],"visibility":"Public","body":"LibLinenoise.set_hints_callback(callback)"}},{"html_id":"set_mask_mode(mask_mode:Bool)-class-method","name":"set_mask_mode","doc":"Set text input masking. This prevents the user's keyboard input from\nbeing echoed automatically to the screen. Instead, the characters all\nget converted to asterisks (*). This is useful when users are entering\npasswords for example.\n\nBy default mask mode is disabled.","summary":"<p>Set text input masking.</p>","abstract":false,"args":[{"name":"mask_mode","external_name":"mask_mode","restriction":"Bool"}],"args_string":"(mask_mode : Bool)","args_html":"(mask_mode : Bool)","location":{"filename":"src/linenoise.cr","line_number":123,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L123"},"def":{"name":"set_mask_mode","args":[{"name":"mask_mode","external_name":"mask_mode","restriction":"Bool"}],"visibility":"Public","body":"if mask_mode\n  LibLinenoise.mask_mode_enable\nelse\n  LibLinenoise.mask_mode_disable\nend"}},{"html_id":"set_multiline(multiline:Bool)-class-method","name":"set_multiline","doc":"Single line mode: Scrolls to the right if input text becomes wider than the current window.\nMutiline mode:    Wraps the input text if it becomes wider than the current window.\n\nDefaults to single line mode.","summary":"<p>Single line mode: Scrolls to the right if input text becomes wider than the current window.</p>","abstract":false,"args":[{"name":"multiline","external_name":"multiline","restriction":"Bool"}],"args_string":"(multiline : Bool)","args_html":"(multiline : Bool)","location":{"filename":"src/linenoise.cr","line_number":106,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L106"},"def":{"name":"set_multiline","args":[{"name":"multiline","external_name":"multiline","restriction":"Bool"}],"visibility":"Public","body":"LibLinenoise.set_multiline(multiline ? 1 : 0)"}}],"types":[{"html_id":"linenoise/Linenoise/Completion","path":"Linenoise/Completion.html","kind":"module","full_name":"Linenoise::Completion","name":"Completion","abstract":false,"locations":[{"filename":"src/linenoise/completion.cr","line_number":9,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise/completion.cr#L9"}],"repository_name":"linenoise","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"linenoise/Linenoise","kind":"module","full_name":"Linenoise","name":"Linenoise"},"doc":"A high-level wrapper around the linenoise completions API\nthat makes it easier to add completions to your program.\n\nNote: By default completions that start with the current line\nare shown in alphabetical order.","summary":"<p>A high-level wrapper around the linenoise completions API that makes it easier to add completions to your program.</p>","class_methods":[{"html_id":"add(completion:String)-class-method","name":"add","doc":"Add a new completion string.\n\nNote: This sets a completion callback internally.","summary":"<p>Add a new completion string.</p>","abstract":false,"args":[{"name":"completion","external_name":"completion","restriction":"String"}],"args_string":"(completion : String)","args_html":"(completion : String)","location":{"filename":"src/linenoise/completion.cr","line_number":65,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise/completion.cr#L65"},"def":{"name":"add","args":[{"name":"completion","external_name":"completion","restriction":"String"}],"visibility":"Public","body":"index = self.find_index(completion)\nif index.nil?\n  @@completions.push(completion)\nelse\n  if @@completions[index] != completion\n    @@completions.insert(index, completion)\n  end\nend\nself.set_callback\n"}},{"html_id":"add(completions:Array(String))-class-method","name":"add","doc":"Add a batch of new completions.\n\nNote: This sets a completion callback internally.","summary":"<p>Add a batch of new completions.</p>","abstract":false,"args":[{"name":"completions","external_name":"completions","restriction":"Array(String)"}],"args_string":"(completions : Array(String))","args_html":"(completions : Array(String))","location":{"filename":"src/linenoise/completion.cr","line_number":80,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise/completion.cr#L80"},"def":{"name":"add","args":[{"name":"completions","external_name":"completions","restriction":"Array(String)"}],"visibility":"Public","body":"if completions.empty?\n  return\nend\n@@completions.concat(completions)\n@@completions.uniq!\n@@completions.sort!\nself.set_callback\n"}},{"html_id":"completion_matches(line:String):Array(String)-class-method","name":"completion_matches","doc":"Finds completion matches that begin with the given line.\nThe results are sorted alphabetically by default.\nThe results are sorted by size if prefer shorter matches is set.\n\nNote: This is made public for testing purposes but doesn't need\nto be called directly.","summary":"<p>Finds completion matches that begin with the given line.</p>","abstract":false,"args":[{"name":"line","external_name":"line","restriction":"String"}],"args_string":"(line : String) : Array(String)","args_html":"(line : String) : Array(String)","location":{"filename":"src/linenoise/completion.cr","line_number":30,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise/completion.cr#L30"},"def":{"name":"completion_matches","args":[{"name":"line","external_name":"line","restriction":"String"}],"return_type":"Array(String)","visibility":"Public","body":"matches = [] of String\nif line.empty?\n  return matches\nend\nindex = self.find_index(line)\nif index.nil?\n  return matches\nend\nwhile index < @@completions.size\n  if @@completions[index].starts_with?(line)\n  else\n    break\n  end\n  matches << @@completions[index]\n  index = index + 1\nend\nif @@prefer_shorter_matches\n  matches.sort_by!(&.size)\nend\nmatches\n"}},{"html_id":"enable_hints!(color:Colorize::ColorANSI|Nil=nil)-class-method","name":"enable_hints!","doc":"Enables hints that match the tab completions.\nHints are shown in dark grey lettering by default to differentiate\nthem from the characters that the user has already typed.\n\nNote: This sets a hints callback internally.","summary":"<p>Enables hints that match the tab completions.</p>","abstract":false,"args":[{"name":"color","default_value":"nil","external_name":"color","restriction":"Colorize::ColorANSI | ::Nil"}],"args_string":"(color : Colorize::ColorANSI | Nil = nil)","args_html":"(color : Colorize::ColorANSI | Nil = <span class=\"n\">nil</span>)","location":{"filename":"src/linenoise/completion.cr","line_number":105,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise/completion.cr#L105"},"def":{"name":"enable_hints!","args":[{"name":"color","default_value":"nil","external_name":"color","restriction":"Colorize::ColorANSI | ::Nil"}],"visibility":"Public","body":"if @@enable_hints\n  return\nend\nif color.nil?\nelse\n  @@hint_color = color.to_i\nend\nLinenoise.set_hints_callback(->(raw_line : Pointer(UInt8), color : Pointer(Int32), attribute : Pointer(Int32)) : Pointer(UInt8) do\n  line = String.new(raw_line)\n  (self.completion_matches(line)).each do |hint|\n    if hint == line\n      next\n    end\n    color.value = @@hint_color\n    attribute.value = 0\n    return hint.byte_slice(start: line.size).to_unsafe\n  end\n  return Pointer(UInt8).null\nend)\n@@enable_hints = true\n"}},{"html_id":"prefer_shorter_matches!-class-method","name":"prefer_shorter_matches!","doc":"Completions will be sorted by size instead of alphabetically.","summary":"<p>Completions will be sorted by size instead of alphabetically.</p>","abstract":false,"location":{"filename":"src/linenoise/completion.cr","line_number":128,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise/completion.cr#L128"},"def":{"name":"prefer_shorter_matches!","visibility":"Public","body":"@@prefer_shorter_matches = true"}},{"html_id":"remove(completion:String)-class-method","name":"remove","doc":"Remove a completion.","summary":"<p>Remove a completion.</p>","abstract":false,"args":[{"name":"completion","external_name":"completion","restriction":"String"}],"args_string":"(completion : String)","args_html":"(completion : String)","location":{"filename":"src/linenoise/completion.cr","line_number":91,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise/completion.cr#L91"},"def":{"name":"remove","args":[{"name":"completion","external_name":"completion","restriction":"String"}],"visibility":"Public","body":"index = self.find_index(completion)\nif index.nil?\n  return\nend\nif @@completions[index] != completion\n  return\nend\n@@completions.delete_at(index)\n"}},{"html_id":"reset!-class-method","name":"reset!","doc":"Resets the completions array, whether shorter matches are preffered,\nhint color, and the callbacks. Mostly just needed for testing.","summary":"<p>Resets the completions array, whether shorter matches are preffered, hint color, and the callbacks.</p>","abstract":false,"location":{"filename":"src/linenoise/completion.cr","line_number":134,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise/completion.cr#L134"},"def":{"name":"reset!","visibility":"Public","body":"@@completions.clear\n@@prefer_shorter_matches = false\n@@hint_color = Colorize::ColorANSI::DarkGray.to_i\n@@set_callback = nil\n@@enable_hints = nil\n"}}]},{"html_id":"linenoise/Linenoise/CompletionCallback","path":"Linenoise/CompletionCallback.html","kind":"alias","full_name":"Linenoise::CompletionCallback","name":"CompletionCallback","abstract":false,"locations":[{"filename":"src/linenoise.cr","line_number":30,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L30"}],"repository_name":"linenoise","program":false,"enum":false,"alias":true,"aliased":"Proc(Pointer(UInt8), Pointer(LibLinenoise::Completions), Nil)","aliased_html":"Pointer(UInt8), Pointer(LibLinenoise::Completions) -> Nil","const":false,"namespace":{"html_id":"linenoise/Linenoise","kind":"module","full_name":"Linenoise","name":"Linenoise"},"doc":"Callback for setting completions based on user input.\n\n- In:  `Pointer(UInt8)`                     The current line as a cstring.\n- In:  `Pointer(LibLinenoise::Completions)` The completion state to be passed to `#add_completion`.\n- Out: `Nil`                                No return value.","summary":"<p>Callback for setting completions based on user input.</p>"},{"html_id":"linenoise/Linenoise/Encoding","path":"Linenoise/Encoding.html","kind":"enum","full_name":"Linenoise::Encoding","name":"Encoding","abstract":false,"ancestors":[{"html_id":"linenoise/Enum","kind":"struct","full_name":"Enum","name":"Enum"},{"html_id":"linenoise/Comparable","kind":"module","full_name":"Comparable","name":"Comparable"},{"html_id":"linenoise/Value","kind":"struct","full_name":"Value","name":"Value"},{"html_id":"linenoise/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/linenoise.cr","line_number":135,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L135"}],"repository_name":"linenoise","program":false,"enum":true,"alias":false,"const":false,"constants":[{"id":"ASCII","name":"ASCII","value":"0_u8"},{"id":"UTF8","name":"UTF8","value":"1_u8"}],"namespace":{"html_id":"linenoise/Linenoise","kind":"module","full_name":"Linenoise","name":"Linenoise"},"instance_methods":[{"html_id":"ascii?-instance-method","name":"ascii?","abstract":false,"location":{"filename":"src/linenoise.cr","line_number":136,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L136"},"def":{"name":"ascii?","visibility":"Public","body":"self == ASCII"}},{"html_id":"utf8?-instance-method","name":"utf8?","abstract":false,"location":{"filename":"src/linenoise.cr","line_number":137,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L137"},"def":{"name":"utf8?","visibility":"Public","body":"self == UTF8"}}]},{"html_id":"linenoise/Linenoise/HintsCallback","path":"Linenoise/HintsCallback.html","kind":"alias","full_name":"Linenoise::HintsCallback","name":"HintsCallback","abstract":false,"locations":[{"filename":"src/linenoise.cr","line_number":57,"url":"https://github.com/apainintheneck/crystal-linenoise/blob/ba3e205f264c7a0d689560bd98f994f4badcbbf5/src/linenoise.cr#L57"}],"repository_name":"linenoise","program":false,"enum":false,"alias":true,"aliased":"Proc(Pointer(UInt8), Pointer(Int32), Pointer(Int32), Pointer(UInt8))","aliased_html":"Pointer(UInt8), Pointer(Int32), Pointer(Int32) -> Pointer(UInt8)","const":false,"namespace":{"html_id":"linenoise/Linenoise","kind":"module","full_name":"Linenoise","name":"Linenoise"},"doc":"Callback for registering hints based on user input.\n\n- In:    `Pointer(UInt8)` The current line as a cstring.\n- Inout: `Pointer(Int32)` The ANSI color code as an integer pointer.\n- Inout: `Pointer(Int32)` The ANSI Select Graphic Rendition (SGR) code as an integer pointer.\n- Out:   `Pointer(UInt8)` Return the hint as a cstring (`String#to_unsafe`).","summary":"<p>Callback for registering hints based on user input.</p>"}]}]}})