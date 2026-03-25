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

### Deploy

To deploy the production version of the application to [GitHub Pages](https://docs.github.com/en/pages):

```bash
nix run .#deploy
```

To simulate the deployment you can do the following:

```bash
nix run .#deploy -- -s
```

### CI

- [`check.yml`](./.github/workflows/check.yml) runs checks on every change you push
- [`deploy.yml`](./.github/workflows/deploy.yml) deploys the production version of the application on every push to the master branch that successfully passes all checks

**N.B.** *The [Magic Nix Cache](https://determinate.systems/blog/magic-nix-cache/) is used for caching the Nix store.*
