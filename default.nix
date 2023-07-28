{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs.ocamlPackages) buildDunePackage;
  inherit (pkgs.ocamlPackages)
    atdgen camlp-streams fmt logs lwt num re result stdlib-shims yojson;

  kappa-library = buildDunePackage {
    pname = "kappa-library";
    version = "1.0";
    src = ./.;

    buildInputs = [ atdgen camlp-streams fmt logs lwt stdlib-shims num yojson ];
  };

in buildDunePackage rec {
  pname = "kappa-binaries";
  version = "4.1.2";
  src = ./.;

  buildInputs = [
    camlp-streams
    fmt
    logs
    lwt
    num
    re
    result
    stdlib-shims
    yojson

    kappa-library
  ];

  preBuild = ''
    echo 'let () = Printf.printf "let t = \"${version}-nix\"\n"' > dev/get-git-version.ml
  '';
}
