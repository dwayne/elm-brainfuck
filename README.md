# Brainfuck

![A screenshot of Brainfuck](/screenshot.png)

A [Brainfuck](https://en.wikipedia.org/wiki/Brainfuck) interpreter written in [Elm](https://elm-lang.org/).

## Usage

An isolated, reproducible development environment is provided with Nix. Enter using:

```bash
nix develop
```

### Chores

When you're in the development environment you can:

- Type `'f'` to run `elm-format`
- Type `'t'` to run `elm-test`
- Type `'d'` to run the application in development mode
- Type `'clean'` to remove build artifacts

### Build

To build the production version of the application:

```bash
nix build -L
# or
nix build .#app -L
```

### Serve

To serve the production version of the application:

```bash
nix run
# or
nix run .#app
```

### Check

```bash
nix flake check -L
```
