require "colorize"

module Linenoise
  # A high-level wrapper around the linenoise completions API
  # that makes it easier to add completions to your program.
  module Completion
    # Memoized completions array that makes it easier to access
    # completions from the completions callback.
    private def self.completions : Array(String)
      @@completions ||= Array(String).new
    end

    # Finds all completions that start with line. They are sorted by line length
    # and alphabetically. This means that shorter matches will show up first.
    private def self.find_matches(line : String) : Array(String)
      left_index = self.completions.bsearch_index do |string|
        string > line && string.starts_with?(line)
      end

      return Array(String).new if left_index.nil?

      first_match = self.completions[left_index]
      right_index = self.completions.bsearch_index do |string|
        string > first_match && !string.starts_with?(line)
      end || self.completions.size

      matches = self.completions[left_index...right_index]
      matches.sort_by!(&.size) if prefer_shorter_matches?
      matches
    end

    # Sets the callback once using memoization to check if it's already set.
    private def self.set_callback
      return if @@set_callback

      Linenoise.set_completion_callback ->(raw_line : Pointer(UInt8), completion_state : Pointer(LibLinenoise::Completions)) do
        line = String.new(raw_line)

        self.find_matches(line).each do |completion|
          Linenoise.add_completion(completion_state, completion)
        end
      end

      @@set_callback = true
    end

    # Add a new completion string.
    #
    # Note: This sets a completion callback internally.
    def self.add(completion : String)
      index = self.completions.bsearch_index { |string| string >= completion }

      if index.nil?
        self.completions.push(completion)
      elsif self.completions[index] != completion
        self.completions.insert(index, completion)
      end

      self.set_callback
    end

    # Add a batch of new completions.
    #
    # Note: This sets a completion callback internally.
    def self.add(completions : Array(String))
      return if completions.empty?

      self.completions.concat(completions)
      self.completions.uniq!
      self.completions.sort!

      self.set_callback
    end

    # Remove a completion.
    def self.remove(completion : String)
      index = self.find_index(completion)

      return if index.nil?
      return if self.completions[index] != completion

      self.completions.delete_at(index)
    end

    # Prioritizes shorter matches when showing completions.
    def self.prefer_shorter_matches!
      @@prefer_shorter_matches = true
    end

    # Whether shorter matching completions should appear first.
    private def self.prefer_shorter_matches?
      @@prefer_shorter_matches
    end

    @@hint_color : Int32?

    # Defaults to dark gray to differentiate it from normal text colors.
    private def self.hint_color : Int32
      @@hint_color ||= Colorize::ColorANSI::DarkGray.to_i
    end

    # Enables hints that match the tab completions.
    # Hints are shown in dark grey lettering by default to differentiate
    # them from the characters that the user has already typed.
    #
    # Note: This sets a hints callback internally.
    def self.enable_hints!(color : Colorize::ColorANSI | Nil = nil)
      return if @@enable_hints

      @@hint_color = color.to_i unless color.nil?

      Linenoise.set_hints_callback ->(raw_line : Pointer(UInt8), color : Pointer(Int32), attribute : Pointer(Int32)) : Pointer(UInt8) do
        line = String.new(raw_line)

        self.find_matches(line).each do |hint|
          next if hint == line

          color.value = self.hint_color
          attribute.value = 0
          return hint.byte_slice(start: line.size).to_unsafe
        end

        return Pointer(UInt8).null
      end

      @@enable_hints = true
    end
  end
end
