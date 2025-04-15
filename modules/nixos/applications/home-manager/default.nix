# This is a NixOS module.
# It defines configuration options and settings related to Home Manager within a NixOS system.
{
  config, # The final NixOS system configuration. Used to access values defined in other modules.
  lib, # Nixpkgs library functions (like mkEnableOption, mkIf).
  namespace, # A unique namespace string for this module set, preventing option name collisions.
  ... # Allows the function to accept additional arguments, though none are used here.
}:

let
  # Inherit commonly used functions from the 'lib' set to avoid writing 'lib.mkEnableOption', etc.
  inherit (lib) mkEnableOption mkIf;

  # Create a local variable 'cfg' to hold the configuration values for this specific module.
  # This makes the code cleaner and easier to read.
  cfg = config.${namespace}.applications.home-manager;
in
{
  # Define the options that users of this module can set in their NixOS configuration.
  options.${namespace}.applications.home-manager = {
    # Create a standard 'enable' option for this module.
    # mkEnableOption generates an option named 'enable' of type boolean,
    # with a default value of 'false' and a description.
    enable = mkEnableOption "home-manager integration for NixOS";
  };

  # Define the actual configuration settings that will be applied to the system
  # if this module is enabled.
  # mkIf ensures that the settings inside this block are only applied if 'cfg.enable' is true.
  config = mkIf cfg.enable {
    # Configure the Home Manager NixOS module.
    home-manager = {
      # When Home Manager manages a file that already exists, it creates a backup.
      # This option specifies the extension for those backup files.
      backupFileExtension = "hm-backup"; # Changed from "./hm-backup" for clarity, NixOS module prepends path.

      # Allow Home Manager configurations to install packages into the user's profile.
      useUserPackages = true;

      # Allow Home Manager configurations to refer to packages defined in the system's nixpkgs instance.
      useGlobalPkgs = true;
    };
  };
}
