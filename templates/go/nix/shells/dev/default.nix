{ mkShell, pkgs, ... }:
mkShell {
  packages = with pkgs; [
    # Go tools
    go
    gotools
    goimports-reviser
    gomodifytags
    impl

    # Dev tools
    air

    # Testing tools
    go-mockery
    go-cover-treemap

    # OpenAPI tools
    go-swagger
    go-swag

    # CI/CD tools
    pre-commit
    detect-secrets
    act
  ];
}
