{ pkgs, ... }:
{
  telescope = {
    enable = true;
    extensions = {
      fzf-native = {
        enable = true;
      };
      ui-select = {
        enable = true;
      };
      file-browser = {
        enable = true;
        settings = {
        };
      };
      frecency = {
        enable = true;
      };
      manix = {
        enable = true;
      };
    };
    settings = { };
  };
  spectre = {
    enable = true;
    replacePackage = pkgs.gnused;
    settings = {
      is_block_ui_break = true;
    };
  };
}
