# Script to check that generated docs are up-to-date.

require "file_utils"

temp_dir = File.tempname("_docs")

begin
  system("crystal \"${@}\"", ["docs", "--output", temp_dir]) &&
    system("diff \"${@}\"", ["-r", "-q", "docs", temp_dir])
ensure
  FileUtils.rm_rf temp_dir
end

exit($?.exit_code)
