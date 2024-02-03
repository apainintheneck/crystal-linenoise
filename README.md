# linenoise

Crystal bindings for the lightweight [Linenoise](https://github.com/antirez/linenoise) line editor library written in C. It is a minimal alternative to readline and libedit.

Linenoise is written in C code that supports most distributions of the Linux, macOS and BSD operating systems. We compile the library on install so linking should not be a problem and the library is lightwieght (less than 900 lines of code) so the resulting binary should be small.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     linenoise:
       github: apainintheneck/crystal-linenoise
   ```

2. Run `shards install`

## Usage

```crystal
require "linenoise"

COMPLETIONS = [
  ...
]

# Enable tab completions.
Linenoise::Completion.add(COMPLETIONS)

# Enable completion hints to the right of the cursor.
Linenoise::Completion.enabe_hints!

HISTORY_FILE = "..."

Linenoise.load_history(HISTORY_FILE)

# A simple REPL.
loop do
  line = Linenoise.prompt("> ")
  break if line.nil?

  # Process line here.

  Linenoise.add_history(line)
  Linenoise.save_history(HISTORY_FILE)
end
```

For more information look at the files in the `example/` directory and the [documentation website](https://apainintheneck.github.io/crystal-linenoise/).

### Multiplexing API

There is no high-level wrapper around the multiplexing API but the Crystal bindings have been added for it. See `src/lib/lib_linenoise.cr` for more details.

## Alternatives

There are a few other line editing libraries available for Crystal.

- [reply](https://github.com/I3oris/reply)
- [fancyline](https://github.com/Papierkorb/fancyline)
- [crystal-readline](https://github.com/crystal-lang/crystal-readline)

## Development

Development setup is mostly managed by the Makefile.

Other than that there is the Linenoise extension in `ext/` that can be built with `make extension`. Keep in mind that this also gets installed automatically in a postinstall step when this shard is included as a dependency and `shard install` is run.

Interactive testing is available using the `example/example.cr` program which allows you to check on different line editing features. It can be run with `make example`. The `make specs` command runs the Crystal specs. The `make expect` command runs tests on this example program using an `expect` script so `expect` will need to be installed to run them.

The `make lint` command checks for linting errors and the `make fix` command fixes them automatically.

The `crystal docs` command can be used to build the docs locally or you can visit the [documentation website](https://apainintheneck.github.io/crystal-linenoise/) that gets generated automatically by the `.github/workflows/docs.yml` workflow.

## Contributing

1. Fork it (<https://github.com/apainintheneck/linenoise/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [apainintheneck](https://github.com/apainintheneck) - creator and maintainer

## License

This library is released under the [MIT license](LICENSE).

The Linenoise library is included in this shard and uses the [BSD-2-Clause license](ext/LICENSE)
which allows code to be used freely as long as the license is included in derivative works.
