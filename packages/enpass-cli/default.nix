{
  fetchFromGitHub,
  stdenv,
  go,
}:
stdenv.mkDerivation rec {
  pname = "enpass-cli";
  version = "1.0.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "hieutran21198";
    repo = "enpass-cli";
    rev = "master";
    hash = "sha256-y2bJX/JQRHhcspxYK4kVXtBFdT4Yo0dc8t3fLZWXzUk=";
  };

  nativeBuildInputs = [
    go
  ];

  installPhase = ''
    mkdir $out/bin

    go mod tidy
    make build
    cp enpass-cli $out/bin/
  '';
}
