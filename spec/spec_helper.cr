require "../src/linenoise.cr"

FIXTURE_DIR = Path.new(__DIR__, "fixture")

def fixture_path(filename : String) : Path
  FIXTURE_DIR / filename
end

def safe_tempfile(suffix : String, close : Bool, &)
  file = File.tempfile(suffix)

  begin
    file.close if close
    yield file
  ensure
    file.delete
  end
end
