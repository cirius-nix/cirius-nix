# This is a NixOS module for configuring AI-related applications, specifically Ollama and a web UI.
{
  config, # The overall NixOS system configuration. Used to read settings from other modules.
  namespace, # A unique identifier for this set of modules to avoid naming conflicts.
  lib, # The Nixpkgs library, providing helper functions like mkEnableOption, mkIf.
  pkgs, # The Nixpkgs package set, used to install software.
  ... # Allows the function to accept additional arguments if needed.
}:
let
  # Create a local variable 'cfg' to easily access the configuration options defined in this module.
  cfg = config.${namespace}.applications.ai;

  # Import a custom helper function 'mkIntOption' from our specific library namespace.
  # This is likely defined elsewhere in the project to create integer options with defaults.
  inherit (lib.${namespace}) mkIntOption;

  # Access the configuration of the GPU drivers module to check if Nvidia drivers are enabled.
  gpuCfg = config.${namespace}.gpu-drivers;

  # Determine the acceleration type for Ollama.
  # If Nvidia drivers are enabled in the 'gpuCfg' module, set acceleration to "cuda".
  # Otherwise, set it to 'null' (meaning no specific hardware acceleration).
  acceleration = if gpuCfg.nvidia.enable then "cuda" else null;
in
{
  # Define the configuration options that users can set for this AI module.
  options.${namespace}.applications.ai = {
    # A standard boolean option to turn the entire AI setup on or off.
    # 'mkEnableOption' creates an option named 'enable' with a description. Defaults to false.
    enable = lib.mkEnableOption "Toggle AI related services like Ollama";

    # An integer option to specify the network port Ollama should listen on.
    # 'mkIntOption' (our custom function) likely sets a default value (11000 here) and a description.
    port = mkIntOption 11000 "Port for the Ollama service";
  };

  # This section defines the actual system configuration changes that will be applied
  # *if* the user has enabled this module (i.e., if cfg.enable is true).
  config = lib.mkIf cfg.enable {

    # Add required packages to the system environment, making them available globally.
    environment.systemPackages = with pkgs; [
      cmake # Build tool, likely a dependency for llama-cpp or other AI tools.
      llama-cpp # Provides tools for running Llama language models locally.
    ];

    # Configure system services (background processes).
    services = {

      # Configure the 'nextjs-ollama-llm-ui' service, a web interface for Ollama.
      nextjs-ollama-llm-ui = {
        enable = true; # Automatically enable this service if the main AI module is enabled.
        port = 11002; # Set the port the web UI will run on.
        # Tell the web UI where to find the Ollama API. It uses the port defined in 'cfg.port'.
        # 'builtins.toString' converts the integer port number to a string for the URL.
        ollamaUrl = "http://127.0.0.1:${builtins.toString cfg.port}";
        hostname = "127.0.0.1"; # Make the web UI listen only on the local machine.
      };

      # Configure the main Ollama service.
      ollama = {
        enable = true; # Automatically enable Ollama if the main AI module is enabled.
        # Set the port Ollama listens on, using the value from the module's options.
        port = cfg.port;
        # Set the hardware acceleration based on the 'acceleration' variable defined above.
        # This will be "cuda" if Nvidia drivers are enabled, otherwise null.
        acceleration = acceleration;
      };
    };
  };
}
