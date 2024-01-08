require "colorize"

module Linenoise
  # A high-level wrapper around the linenoise hints API
  # that makes it easier to add hints to your program.
  module Hints
    # Representation of the data passed to linenoise in the `#hints_callback`.
    struct Hint
      # The text the line must match to trigger the hint.
      getter text : String

      # The ANSI color code of the hint.
      getter color : Colorize::ColorANSI

      # ANSI Select Graphic Rendition (SGR) attribute of the hint.
      # Note: The majority of these are not portable but 1 does indicate bold text.
      getter attribute : Int32

      def initialize(@text, @color = Colorize::ColorANSI::DarkGray, @attribute = 0)
      end
    end

    # Memoized collection of hints so that they can be accessed from the callback.
    private def self.hints
      @@hints ||= Hash(String, Hint).new
    end

    # Sets the callback once using memoization to check if it's already set.
    private def self.set_callback
      return if @@set_callback

      Linenoise.set_hints_callback ->(raw_line : Pointer(UInt8), color : Pointer(Int32), attribute : Pointer(Int32)) : Pointer(UInt8) do
        line = String.new(raw_line)
        hint = self.hints[line]?
        return Pointer(UInt8).null if hint.nil?

        color.value = hint.color.to_i
        attribute.value = hint.attribute
        return hint.text.to_unsafe
      end

      @@set_callback = true
    end

    # Add a new hint. The line is the string that triggers the hint to be shown.
    def self.add(line : String, hint : Hint)
      self.hints[line] = hint
      self.set_callback
    end

    # Add new batch of hints.
    # Takes a hash of lines to match and the hints that go with them.
    def self.add(hints = Hash(String, Hint).new)
      return if hints.empty?

      self.hints.merge(hints)
      self.set_callback
    end

    # Remove a hint.
    def self.remove(name : String)
      self.hints.delete(name)
    end

    # Reset the hints callback and hints collections.
    def self.reset
      if @@set_callback
        Linenoise.set_hints_callback Null
        @@set_callback = false
      end

      @@hints = nil
    end
  end
end
