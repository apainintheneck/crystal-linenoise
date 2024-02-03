require "spec"
require "../spec_helper.cr"

module Linenoise
  module Completion
    def self.completions_array
      @@completions
    end
  end
end

describe Linenoise::Completion do
  after_each do
    Linenoise::Completion.reset!
  end

  describe ".add" do
    it "adds completions individually" do
      Linenoise::Completion.add("one")
      Linenoise::Completion.completions_array.should eq %w[one]

      Linenoise::Completion.add("two")
      Linenoise::Completion.completions_array.should eq %w[one two]

      Linenoise::Completion.add("three")
      Linenoise::Completion.completions_array.should eq %w[one three two]
    end

    it "adds completions in batches" do
      Linenoise::Completion.add(%w[one two three])
      Linenoise::Completion.completions_array.should eq %w[one three two]
    end

    it "does not add duplicates" do
      Linenoise::Completion.add(%w[one two two three])
      Linenoise::Completion.add("one")
      Linenoise::Completion.completions_array.should eq %w[one three two]
    end
  end

  describe ".remove" do
    it "removes completions individually" do
      Linenoise::Completion.add(%w[one two three])

      Linenoise::Completion.remove("one")
      Linenoise::Completion.completions_array.should eq %w[three two]

      Linenoise::Completion.remove("two")
      Linenoise::Completion.completions_array.should eq %w[three]
    end

    it "skips removing completion when there are none" do
      Linenoise::Completion.remove("two")
      Linenoise::Completion.completions_array.should eq [] of String
    end

    it "skips removing completion that does not exist" do
      Linenoise::Completion.add(%w[one two three])

      Linenoise::Completion.remove("four")
      Linenoise::Completion.completions_array.should eq %w[one three two]
    end
  end

  describe ".completion_matches" do
    it "returns no matches to an empty string" do
      Linenoise::Completion.add(%w[one two three four five six seven])

      Linenoise::Completion.completion_matches("").should eq [] of String
    end

    it "returns matches in alphabetical order" do
      Linenoise::Completion.add(%w[one two three four five six seven])

      Linenoise::Completion.completion_matches("t").should eq %w[three two]
      Linenoise::Completion.completion_matches("s").should eq %w[seven six]
    end

    describe ".prefer_shorter_matches!" do
      before_each do
        Linenoise::Completion.prefer_shorter_matches!
      end

      it "returns matches in order by string size" do
        Linenoise::Completion.add(%w[one two three four five six seven])

        Linenoise::Completion.completion_matches("t").should eq %w[two three]
        Linenoise::Completion.completion_matches("s").should eq %w[six seven]
      end
    end
  end
end
