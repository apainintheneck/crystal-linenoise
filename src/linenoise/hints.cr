require "colorize"

module Linenoise
  module Hints
    struct Hint
      getter text : String
      getter color : Colorize::ColorANSI
      getter attribute : Int32 # ANSI Select Graphic Rendition (SGR)

      def initialize(@text, @color = Colorize::ColorANSI::DarkGray, @attribute = 0)
      end
    end

    private def self.hints
      @@hints ||= Hash(String, Hint).new
    end

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

    def self.add(hints = Hash(String, Hint).new)
      return if hints.empty?

      self.hints.merge(hints)
      self.set_callback
    end

    def self.add(name : String, hint : Hint)
      self.hints[name] = hint
      self.set_callback
    end

    def self.remove(name : String) : Hint
      self.hints.delete(name)
    end

    def self.reset
      if @@set_callback
        # Set empty callback to avoid unnecessary work if one was already set before.
        Linenoise.set_hints_callback ->(raw_line : Pointer(UInt8), color : Pointer(Int32), bold : Pointer(Int32)) : Pointer(UInt8) do
          return Pointer(UInt8).null
        end
        @@set_callback = false
      end

      @@hints = nil
    end
  end
end
