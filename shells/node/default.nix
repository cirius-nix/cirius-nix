{ lib
, # You also have access to your flake's inputs.
  inputs
, # The namespace used for your flake, defaulting to "internal" if not set.
  namespace
, # All other arguments come from NixPkgs. You can use `pkgs` to pull shells or helpers
  # programmatically or you may add the named attributes as arguments here.
  pkgs
, mkShell
, ...
}:

mkShell {
  # Create your shell
  packages = with pkgs; [
    corepack_22
    nodejs_22
    jq
  ];
}
