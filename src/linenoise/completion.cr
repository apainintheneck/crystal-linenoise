require "colorize"

module Linenoise
  # A high-level wrapper around the linenoise completions API
  # that makes it easier to add completions to your program.
  #
  # Note: By default completions that start with the current line
  # are shown in alphabetical order.
  module Completion
    # Defaults to dark gray to differentiate it from normal text colors.
    @@hint_color : Int32 = Colorize::ColorANSI::DarkGray.to_i

    # By default completions are sorted alphabetically.
    @@prefer_shorter_matches = false

    # The list of all completions that is sorted alphabetically for searchability.
    @@completions = [] of String

    # Find the index of the closest match to the given line.
    private def self.find_index(line : String) : Int32?
      @@completions.bsearch_index { |string| string >= line }
    end

    # Finds completion matches that begin with the given line.
    # The results are sorted alphabetically by default.
    # The results are sorted by size if prefer shorter matches is set.
    #
    # Note: This is made public for testing purposes but doesn't need
    # to be called directly.
    def self.completion_matches(line : String) : Array(String)
      matches = [] of String
      return matches if line.empty?

      index = self.find_index(line)
      return matches if index.nil?

      while index < @@completions.size
        break unless @@completions[index].starts_with?(line)

        matches << @@completions[index]
        index += 1
      end

      matches.sort_by!(&.size) if @@prefer_shorter_matches
      matches
    end

    # Sets the callback once using memoization to check if it's already set.
    private def self.set_callback
      return if @@set_callback

      Linenoise.set_completion_callback ->(raw_line : Pointer(UInt8), completion_state : Pointer(LibLinenoise::Completions)) do
        line = String.new(raw_line)
        self.completion_matches(line).each do |completion|
          Linenoise.add_completion(completion_state, completion)
        end
      end

      @@set_callback = true
    end

    # Add a new completion string.
    #
    # Note: This sets a completion callback internally.
    def self.add(completion : String)
      index = self.find_index(completion)

      if index.nil?
        @@completions.push(completion)
      elsif @@completions[index] != completion
        @@completions.insert(index, completion)
      end

      self.set_callback
    end

    # Add a batch of new completions.
    #
    # Note: This sets a completion callback internally.
    def self.add(completions : Array(String))
      return if completions.empty?

      @@completions.concat(completions)
      @@completions.uniq!
      @@completions.sort!

      self.set_callback
    end

    # Remove a completion.
    def self.remove(completion : String)
      index = self.find_index(completion)

      return if index.nil?
      return if @@completions[index] != completion

      @@completions.delete_at(index)
    end

    # Enables hints that match the tab completions.
    # Hints are shown in dark grey lettering by default to differentiate
    # them from the characters that the user has already typed.
    #
    # Note: This sets a hints callback internally.
    def self.enable_hints!(color : Colorize::ColorANSI? = nil)
      return if @@enable_hints

      @@hint_color = color.to_i unless color.nil?

      Linenoise.set_hints_callback ->(raw_line : Pointer(UInt8), color : Pointer(Int32), attribute : Pointer(Int32)) : Pointer(UInt8) do
        line = String.new(raw_line)

        self.completion_matches(line).each do |hint|
          next if hint == line

          color.value = @@hint_color
          attribute.value = 0
          return hint.byte_slice(start: line.size).to_unsafe
        end

        return Pointer(UInt8).null
      end

      @@enable_hints = true
    end

    # Completions will be sorted by size instead of alphabetically.
    def self.prefer_shorter_matches!
      @@prefer_shorter_matches = true
    end

    # Resets the completions array, whether shorter matches are preffered,
    # hint color, and the callbacks. Mostly just needed for testing.
    def self.reset!
      @@completions.clear
      @@prefer_shorter_matches = false
      @@hint_color = Colorize::ColorANSI::DarkGray.to_i
      @@set_callback = nil
      @@enable_hints = nil
    end
  end
end
