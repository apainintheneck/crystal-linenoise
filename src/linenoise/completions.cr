module Linenoise
  module Completion
    private def self.completions : Array(String)
      @@completions ||= Array(String).new
    end

    private def self.find_index(line : String) Int32 | Nil
      self.completions.bsearch_index { |string| string >= line }
    end

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

    private def self.set_callback
      return if @@set_callback

      Linenoise.set_completion_callback ->(raw_line : Pointer(UInt8), completion_state : Pointer(LibLinenoise::Completions)) do
        self.each_completion(String.new(raw_line)) do |completion|
          Linenoise.add_completion(completion_state, completion)
        end
      end

      @@set_callback = true
    end

    def self.add(completion : String)
      index = self.find_index(completion)

      if index.nil?
        self.completions.push(completion)
      elsif self.completions[index] != completion
        self.completions.insert(index, completion)
      end
    end

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

    def self.remove(completion : String) : String
      index = self.find_index(completion)

      return if index.nil?
      return if self.completions[index] != completion

      self.completions.delete_at(index)
    end

    def self.enable_hints
      return if @@enable_hints

      Linenoise.set_hints_callback ->(raw_line : Pointer(UInt8), color : Pointer(Int32), bold : Pointer(Int32)) : Pointer(UInt8) do
        line = String.new(raw_line)

        self.each_completion(line) do |hint|
          next if hint == line

          color.value = Colorize::ColorANSI::DarkGray.to_i
          bold.value = 0
          return hint.byte_slice(start: line.size).to_unsafe
        end

        return Pointer(UInt8).null
      end

      @@enable_hints = true
    end

    def self.reset
      if @@set_callback
        Linenoise.set_completion_callback ->(raw_line : Pointer(UInt8), completion_state : Pointer(LibLinenoise::Completions)) do
          # Set empty callback to avoid unnecessary work if one was already set before.
        end
        @@set_callback = false
      end

      @@completions = nil

      if @@enable_hints
        Linenoise.set_hints_callback ->(raw_line : Pointer(UInt8), color : Pointer(Int32), bold : Pointer(Int32)) : Pointer(UInt8) do
          return Pointer(UInt8).null # Set empty callback to avoid unnecessary work if one was already set before.
        end
        @@enable_hints = false
      end
    end
  end
end
