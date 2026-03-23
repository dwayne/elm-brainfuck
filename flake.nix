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
          ];

          shellHook = ''
            export PROJECT_ROOT="$PWD"
            export PS1="($name)\n$PS1"

            format () {
              elm-format "$PROJECT_ROOT/"{src,tests} "''${@:---yes}"
            }
            alias f='format'

            alias t='elm-test'
          '';
        };
      }
    );
}
