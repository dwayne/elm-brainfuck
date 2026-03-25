{
  inputs = {
    deploy = {
      url = "github:dwayne/deploy";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    elm2nix = {
      url = "github:dwayne/elm2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, deploy, elm2nix }:
    flake-utils.lib.eachDefaultSystem(system:
      let
        name = "elm-brainfuck";

        pkgs = nixpkgs.legacyPackages.${system};
        inherit (elm2nix.lib.elm2nix pkgs)
          buildElmApplication
          generateRegistryDat
          prepareElmHomeScript;

        app = pkgs.callPackage ./nix/app.nix {
          inherit name generateRegistryDat prepareElmHomeScript;
          version = "0.0.1";
        };

        serve = pkgs.callPackage ./nix/serve.nix {} {
          inherit name;
          root = app;
        };

        deployApp = pkgs.writeShellScript "deploy-${name}" ''
          ${deploy.packages.${system}.default}/bin/deploy "$@" ${app} gh-pages
        '';

        mkApp = { drv, description }: {
          type = "app";
          program = "${drv}";
          meta.description = description;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          inherit name;

          packages = [
            elm2nix.packages.${system}.default
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

        packages = {
          inherit app;
          default = app;
        };

        apps = {
          default = self.apps.${system}.app;

          app = mkApp {
            drv = serve;
            description = "Serve the production version of the web application";
          };

          deploy = mkApp {
            drv = deployApp;
            description = "Deploy the production version of the web application";
          };
        };

        checks = {
          inherit app serve deployApp;
        };
      }
    );
}
