inputs:
let
  ai = import ./plugins/ai.nix;
  debugging = import ./plugins/debugging.nix;
  editor = import ./plugins/editor.nix;
  git = import ./plugins/git.nix;
  lsp = import ./plugins/lsp.nix inputs;
  testing = import ./plugins/testing.nix;
  ui = import ./plugins/ui.nix;
  workspace = (import ./plugins/workspace.nix) inputs;
in
ai // debugging // editor // git // lsp // testing // ui // workspace
