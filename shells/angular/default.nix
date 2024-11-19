{ mkShell, pkgs, ... }: mkShell {
  packages = with pkgs; [
    nodePackages."@angular/cli"
    nodejs_22
    pnpm
    yarn
  ];

  shellHooks = ''
    echo 🔨 Angular DevShell
  '';
}
