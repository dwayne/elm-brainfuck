{ callPackage
, elmPackages
, fetchPnpmDeps
, lib
, nodejs
, pnpm
, pnpmConfigHook
, stdenv

, name
, version
, generateRegistryDat
, prepareElmHomeScript
}:

let
  fs = lib.fileset;

  elmLock = ../elm.lock;
  registryDat = generateRegistryDat { inherit elmLock; };
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;

  pname = name;

  src = fs.toSource {
    root = ../.;
    fileset = fs.unions [
      ../src
      ../elm.json
      ../package.json
      ../pnpm-lock.yaml
    ];
  };

  nativeBuildInputs = [
    elmPackages.elm
    nodejs
    pnpmConfigHook
    pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-+VzwvSEwZXP93lMp4JaB4f64uUbA7E8LAZIcikdWnxg=";
  };

  buildPhase = ''
    runHook preBuild

    ${prepareElmHomeScript { inherit elmLock registryDat; }}

    pnpm build src/index.html
    cp -R dist/ "$out"/
    touch "$out/.nojekyll"

    runHook postBuild
  '';
})
