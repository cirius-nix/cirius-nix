{
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.${namespace}.development.cli-utils) starship fish;
in
{
  options.${namespace}.development.cli-utils.starship = {
    enable = mkEnableOption "Enable starship";
  };

  config = mkIf starship.enable {
    programs = {
      starship = {
        enable = true;
        enableFishIntegration = fish.enable;
        settings = {
          "$schema" = "https://starship.rs/config-schema.json";

          format = ''
            [](red)$os$username[](bg:peach fg:red)$directory[](bg:yellow fg:peach)$git_branch$git_status[](fg:yellow bg:green)$c$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:green bg:sapphire)$conda[](fg:sapphire bg:lavender)$time[ ](fg:lavender)$cmd_duration$line_break$character
          '';

          os = {
            disabled = false;
            style = "bg:red fg:crust";
            symbols = {
              Windows = "";
              Ubuntu = "󰕈";
              SUSE = "";
              Raspbian = "󰐿";
              Mint = "󰣭";
              Macos = "󰀵";
              Manjaro = "";
              Linux = "󰌽";
              Gentoo = "󰣨";
              Fedora = "󰣛";
              Alpine = "";
              Amazon = "";
              Android = "";
              Arch = "󰣇";
              Artix = "󰣇";
              CentOS = "";
              Debian = "󰣚";
              Redhat = "󱄛";
              RedHatEnterprise = "󱄛";
            };
          };

          username = {
            show_always = true;
            style_user = "bg:red fg:crust";
            style_root = "bg:red fg:crust";
            format = "[ $user]($style)";
          };

          directory = {
            style = "bg:peach fg:crust";
            format = "[ $path ]($style)";
            truncation_length = 3;
            truncation_symbol = "…/";
            substitutions = {
              "Documents" = "󰈙 ";
              "Downloads" = " ";
              "Music" = "󰝚 ";
              "Pictures" = " ";
              "Developer" = "󰲋 ";
            };
          };
        };
      };
    };
  };
}
