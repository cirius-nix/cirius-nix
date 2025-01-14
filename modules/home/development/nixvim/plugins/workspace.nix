{ pkgs, ... }:
{
  snacks = {
    enable = false;
    settings = { };
  };
  telescope = {
    enable = true;
    settings =
      {
      };
    extensions = {
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
