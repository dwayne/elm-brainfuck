{
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          name = "elm-brainfuck";

          packages = [
            pkgs.elmPackages.elm
            pkgs.elmPackages.elm-format
            pkgs.elmPackages.elm-test
            pkgs.nodejs-slim_24
            pkgs.pnpm
          ];

          shellHook = ''
            export PROJECT_ROOT="$PWD"
            export PS1="($name)\n$PS1"
            export PATH="$PROJECT_ROOT/node_modules/.bin:$PATH"

            if [ ! -d "$PROJECT_ROOT/node_modules" ]; then
              pnpm install --silent
            fi

            format () {
              elm-format "$PROJECT_ROOT/"{src,tests} "''${@:---yes}"
            }
            alias f='format'

            alias t='elm-test'

            dev () {
              parcel "$PROJECT_ROOT/src/index.html"
            }
            alias d='dev'

            clean () {
              rm -rf "$PROJECT_ROOT/"{.parcel-cache,dist,elm-stuff,node_modules}
            }

            if [[ $- == *i* ]]; then
              echo "Development environment loaded"
              echo ""
              echo "Type 'f' to run elm-format"
              echo "Type 't' to run elm-test"
              echo "Type 'd' to run the application in development mode"
              echo "Type 'clean' to remove build artifacts"
              echo ""
            fi
          '';
        };
      }
    );
}
