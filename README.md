# linenoise

Note: This is still a work in progress.

Crystal bindings for the lightweight [Linenoise](https://github.com/antirez/linenoise) line editor library written in C. It is a minimal alternative to readline and libedit.

Linenoise is written in C code that supports most distributions of the Linux, macOS and BSD operating systems. We compile the library on install so linking should not be a problem and the library is lightwieght (less than 900 lines of code) so the resulting binary should be small.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     linenoise:
       github: apainintheneck/linenoise
   ```

2. Run `shards install`

## Usage

```crystal
require "linenoise"
```

## Development

Development setup is mostly managed by the Makefile.

Interactive testing is available using the `example/example.cr` program which allows you to interactively check on different line editing features. It can be run with `make example`.

Other than that there is the Linenoise extension in `ext/` that can be built with `make extension`. Keep in mind that this also gets installed automatically in a postinstall step when this shard is included as a dependency and `shard install` is run.

The `crystal tool format` command is used for linting and `crystal docs` can be used to build the docs locally.

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
