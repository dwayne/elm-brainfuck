# Brainfuck

![A screenshot of Brainfuck](/screenshot.png)

A [Brainfuck](https://en.wikipedia.org/wiki/Brainfuck) interpreter written in [Elm](https://elm-lang.org/).

## Usage

An isolated, reproducible development environment is provided with Nix. Enter using:

```nix
nix develop
```

When you're in the development environment you can:

- Type `'f'` to run `elm-format`
- Type `'t'` to run `elm-test`
- Type `'d'` to run the application in development mode
- Type `'clean'` to remove build artifacts
