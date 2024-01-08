module Linenoise
  # A high-level wrapper around the linenoise completions API
  # that makes it easier to add completions to your program.
  module Completion
    # Memoized completions array that makes it easier to access
    # completions from the completions callback.
    private def self.completions : Array(String)
      @@completions ||= Array(String).new
    end

    # Find the index of the closest match to the given line.
    private def self.find_index(line : String) Int32 | Nil
      self.completions.bsearch_index { |string| string >= line }
    end

    # Yields each completion that begins with the given line as a `String`.
    # The results are sorted by closest match.
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

    # Sets the callback once using memoization to check if it's already set.
    private def self.set_callback
      return if @@set_callback

      Linenoise.set_completion_callback ->(raw_line : Pointer(UInt8), completion_state : Pointer(LibLinenoise::Completions)) do
        self.each_completion(String.new(raw_line)) do |completion|
          Linenoise.add_completion(completion_state, completion)
        end
      end

      @@set_callback = true
    end

    # Add a new completion string.
    def self.add(completion : String)
      index = self.find_index(completion)

      if index.nil?
        self.completions.push(completion)
      elsif self.completions[index] != completion
        self.completions.insert(index, completion)
      end
    end

    # Add a batch of new completions.
    def self.add(completions : Array(String))
      return if completions.empty?

      if self.completions.empty?
        self.completions = completions.sort
      else
        self.completions.concat(completions)
        self.completions.uniq!
        self.completions.sort!
      end
    end

    # Remove a completion.
    def self.remove(completion : String)
      index = self.find_index(completion)

      return if index.nil?
      return if self.completions[index] != completion

      self.completions.delete_at(index)
    end

    # Defaults to dark gray to differentiate it from normal text colors.
    private def self.hint_color
      @@hint_color ||= Colorize::ColorANSI::DarkGray.to_i
    end

    # Enables hints that match the tab completions.
    # Hints are shown in dark grey lettering by default to differentiate
    # them from the characters that the user has already typed.
    #
    # Note: This sets a hints callback internally.
    def self.enable_hints(color : Colorize::ColorANSI | Nil = nil)
      return if @@enable_hints

      @@hint_color = color.to_i unless color.nil?

      Linenoise.set_hints_callback ->(raw_line : Pointer(UInt8), color : Pointer(Int32), attribute : Pointer(Int32)) : Pointer(UInt8) do
        line = String.new(raw_line)

        self.each_completion(line) do |hint|
          next if hint == line

          color.value = self.hint_color
          attribute.value = 0
          return hint.byte_slice(start: line.size).to_unsafe
        end

        return Pointer(UInt8).null
      end

      @@enable_hints = true
    end

    # Reset the completion and hints callbacks along the completions array.
    def self.reset
      if @@set_callback
        Linenoise.set_completion_callback Null
        @@set_callback = false
      end

      @@completions = nil

      if @@enable_hints
        Linenoise.set_hints_callback Null
        @@enable_hints = false
      end
    end
  end
end
