{ pkgs, ... }:
{
  telescope = {
    enable = true;
  };
  spectre = {
    enable = true;
    replacePackage = pkgs.gnused;
    settings = {
      is_block_ui_break = true;
    };
  };
}
