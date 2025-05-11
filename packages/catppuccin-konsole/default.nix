{
  fetchFromGitHub,
  python3,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "catppuccin-konsole";
  version = "1.0.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "konsole";
    rev = "main";
    hash = "sha256-d5+ygDrNl2qBxZ5Cn4U7d836+ZHz77m6/yxTIANd9BU=";
  };

  nativeBuildInputs = [
    python3
  ];

  installPhase = ''
    mkdir -p $out/json-themes
    for ini in themes/*.colorscheme; do
      json_name=$(basename "$ini")
      python3 -c "import configparser, json; \
        c = configparser.ConfigParser(); \
        c.optionxform = lambda option: option; \
        c.read('$ini'); \
        d = {s: dict(c.items(s)) for s in c.sections()}; \
        json.dump(d, open('$out/json-themes/$json_name', 'w'), indent=2)"
    done
  '';
}
