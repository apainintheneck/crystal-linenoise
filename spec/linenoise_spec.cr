require "spec"
require "./spec_helper.cr"

describe Linenoise do
  describe "history" do
    # This is an ugly integration test because I couldn't figure out how to make multiple
    # tests run well in parallel since the history is essentially a global resource in Linenoise.
    it "loads, adds to and saves the history" do
      # Loading History
      Linenoise.load_history(fixture_path("one_to_ten.history").to_s)

      safe_tempfile(suffix: ".history", close: true) do |file|
        Linenoise.save_history(file.path)

        File.same_content?(fixture_path("one_to_ten.history"), file.path).should be_true
      end

      # Adding History
      %w[
        eleven
        twelve
        thirteen
        fourteen
        fifteen
        sixteen
        seventeen
        eighteen
        nineteen
        twenty
      ].each do |line|
        Linenoise.add_history(line)
      end

      safe_tempfile(suffix: ".history", close: true) do |file|
        Linenoise.save_history(file.path)

        File.same_content?(fixture_path("one_to_twenty.history"), file.path).should be_true
      end

      # Setting Max History
      Linenoise.max_history(10)
      Linenoise.load_history(fixture_path("one_to_twenty.history").to_s)

      safe_tempfile(suffix: ".history", close: true) do |file|
        Linenoise.save_history(file.path)

        File.same_content?(fixture_path("eleven_to_twenty.history"), file.path).should be_true
      end
    end
  end
end
