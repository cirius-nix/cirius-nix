# Packages

All packages under this folder will be built and used directly by:
`pkgs.${namespace}.${package_name}`

Templates:

```nix
{
  lua,
  fetchFromGitHub
}:
lua.stdenv.mkDerivation rec {
  pname = "package_name";
  version = "raw_version";
  name = "prettier_name";
  # use nix-prefetch-github to get rev and hash.
  src = fetchFromGitHub {
    owner = "";
    repo = "";
    rev = "";
    hash = "";
  };
  nativeBuildInputs = [
  ];
  buildInputs = [ ];
  propagatedBuildInputs = [ ];
  makeFlags = [
  ];
  installPhase = ''
  '';
}
```
