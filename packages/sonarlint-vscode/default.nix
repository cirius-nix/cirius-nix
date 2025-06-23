{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "sonarlint-vscode";
  version = "4.24.0";

  src = pkgs.fetchurl {
    url = "https://github.com/SonarSource/sonarlint-vscode/releases/download/4.24.0%2B77775/sonarlint-vscode-${
      if pkgs.stdenv.isLinux then "linux" else "darwin"
    }-${if pkgs.stdenv.isAarch64 then "arm64" else "x64"}-4.24.0.vsix";
    sha256 = "sha256-BbSE8ewKb+uRfYvsuspWGAOyt/Rjk57C/llrTxhNNEw=";
  };

  nativeBuildInputs = [ pkgs.unzip ];

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out
    unzip -q $src -d $out
  '';
}
