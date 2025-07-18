{ mkShell, pkgs, ... }:
mkShell {
  packages = with pkgs; [
    go

    # go tools
    gotools
    goimports-reviser
    gomodifytags
    impl

    # devtools
    air

    # Testing tools
    go-mockery
    go-cover-treemap

    # OpenAPI tools
    go-swagger
    go-swag # tools

    # CI/CD tools
    pre-commit
    detect-secrets
    act
  ];
}
