## Linenoise Extension Changes

All credit goes to antirez as mentioned in the license includes in this directory.

---

## Branch: Master

- Last Copied
  - 2023-12-31
- Last Commit
  - Date
    - 2032-03-27
  - SHA
    - 93b2db9bd4968f76148dd62cdadf050ed50b84b3
- Repo URL
  - `https://github.com/antirez/linenoise`
- Note
  - This is the original commit I moved over.

---

## Branch: Fixed warnings when using -Wall -Wextra -Wpedantic -std=c11

- Last Copied
  - 2024-02-03
- Last Commit
  - Date
    - 2019-09-24
  - SHA
    - 01c74fb4905256b48665069d1362fd5575ca7ca9
- Branch URL
  - `https://github.com/antirez/linenoise/pull/173`
- User URL
  - `https://github.com/emvigo`
- Note
  - This branch helped fix a bug on Linux with command line history.

---

## Branch: Bug fix when the prompt contains ESC chars

- Last Copied
  - 2024-02-05
- Last Commit
  - Date
    - 2017-02-28
  - SHA
    - be1fc44d69fbf37587b50e4aed42efbe7d925174
- Branch URL
  - `https://github.com/antirez/linenoise/pull/135`
- User URL
  - `https://github.com/olegat`
- Note
  - This branch helped fix a bug where the cursor would be offset
    when using escape codes because it was calculating the literal
    offset instead of the visual offset.

---

## Branch: Remove extra unistd.h include

- Last Copied
  - 2024-02-10
- Last Commit
  - Date
    - 2017-04-17
  - SHA
    - c1afa560fd11825774df8233363c3b611dac6683
- Branch URL
  - `https://github.com/antirez/linenoise/pull/139`
- User URL
  - `https://github.com/gdawg`
- Note
  - This just removes an extra include.

---

## Branch: Another implementation for utf8 support

- Last Copied
  - 2024-02-26
- Last Commit
  - Date
    - 2024-04-19
  - SHA
    - 34fbffeef4489418527e1267e8e5c093b58aa5d4
- Branch URL
  - `https://github.com/antirez/linenoise/pull/187`
- User URL
  - `https://github.com/yhirose`
- Note
  - This is a massive PR which provides UTF8 support and at
    the same time fixes the cursor position errors in multiline
    mode. It currently supports Unicode 14.0.
  - The list of UTF-8 character mappings was created by parsing
    the UTF-8 character files downloaded from the Unicode
    Consortium website.

---

## Branch: advance enableRawMode() before getColumns()

- Last Copied
  - 2024-05-06
- Last Commit
  - Date
    - 2024-02-22
  - SHA
    - 4111f1d6cd29e136b4e86a25d1dd859a1e00813b
- Branch URL
  - `https://github.com/antirez/linenoise/pull/221`
- User URL
  - `https://github.com/9Ajiang`
- Note
  - Stops control characters from being printed to the screen if
    the call to `ioctl` in `getColumns` fails.