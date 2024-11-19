{ mkShell, pkgs, ... }: mkShell {
  packages = with pkgs; [
    go
    gotools
    goimports-reviser
    gomodifytags
    impl
    go-swag
  ];

  shellHooks = ''
    echo 🔨 Golang DevShell
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$PATH

    if !command -v mockery >/dev/null 2>&1; then
      go install github.com/vektra/mockery/v2@v2.46.3
    fi

    if !command -v go-cover-treemap >/dev/null 2>&1; then
      go install github.com/nikolaydubina/go-cover-treemap@latest
    fi

    source .env
  '';
}
