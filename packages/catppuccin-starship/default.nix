{
  fetchFromGitHub,
  python3,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "catppuccin-starship";
  version = "1.0.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "starship";
    rev = "main";
    hash = "";
  };

  nativeBuildInputs = [
    python3
  ];

  installPhase = ''
    mkdir -p $out/json-themes
    for toml in themes/*.toml; do
      json_name=$(basename "$toml" .toml).json
      python3 -c "import toml, json; \
        with open('$toml') as f: data = toml.load(f); \
        json.dump(data, open('$out/json-themes/$json_name', 'w'), indent=2)"
    done
  '';
}
