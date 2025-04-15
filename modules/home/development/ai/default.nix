# This is a Home Manager module for configuring AI development tools like Ollama and Tabby.
# It sets up packages, configuration files, and services based on user options and the operating system.
{
  config, # The overall Home Manager configuration for the current user.
  namespace, # A unique identifier for this set of modules to avoid naming conflicts.
  lib, # The Nixpkgs library, providing helper functions.
  osConfig, # The NixOS system configuration (used to check system-level settings like GPU drivers).
  pkgs, # The Nixpkgs package set, used to install software.
  ... # Allows the function to accept additional arguments if needed.
}:
let
  # --- Basic Flags and Configuration Shortcuts ---

  # Detect the current operating system.
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;

  # Shortcut to access the configuration options defined in *this* module.
  moduleCfg = config.${namespace}.development.ai;

  # Shortcut to access the configuration of the system-level AI applications module (defined in NixOS).
  # This is used to get the Ollama port if running on Linux, where Ollama might be a system service.
  osAiModuleCfg = osConfig.${namespace}.applications.ai;

  # Shortcut to access the user configuration module (e.g., to get the home directory).
  userModuleCfg = config.${namespace}.user;

  # Check if Nvidia drivers are enabled in the system-level configuration.
  enabledNvidia = osConfig.${namespace}.gpu-drivers.nvidia.enable;

  # --- Library Functions ---

  # Import custom helper functions for creating module options from our specific library namespace.
  inherit (lib.${namespace})
    mkIntOption # Creates an integer option with a default value and description.
    mkAttrsOption # Creates an attribute set option with defaults and types.
    mkListOption # Creates a list option with a specific sub-type.
    mkStrOption # Creates a string option with a default value and description.
    subModuleType # Helper for defining the type of items within a list or attribute set option.
    ;

  # --- OS-Specific Configuration Logic ---

  # Determine the final configuration values based on the OS and module options.
  # This merges settings from this Home Manager module and potentially the system-level NixOS module.
  osMergedCfg = {
    # On Linux, prefer the Ollama port defined in the system-level NixOS module (osAiModuleCfg).
    # On macOS, use the port defined in this Home Manager module (moduleCfg).
    # This assumes Ollama runs as a system service on Linux but potentially as a user service/app on macOS via this module.
    port = if isLinux then osAiModuleCfg.port else moduleCfg.port;

    # Use the Tabby configuration directly from this module's options.
    tabby = moduleCfg.tabby;
  };

  # --- Helper Functions ---

  # Converts a Nix attribute set (like { key1 = "value1"; key2 = "value2"; })
  # into a multi-line string suitable for TOML configuration files.
  # Example output:
  # key1 = "value1"
  # key2 = "value2"
  attrsToString =
    attrs:
    let
      keys = builtins.attrNames attrs; # Get the names of the attributes (keys).
      # Create a list of strings like 'key = "value"'.
      keyValues = map (k: "${k} = \"${attrs.${k}}\"") keys;
    in
    # Join the list of strings with newline characters.
    builtins.concatStringsSep "\n" keyValues;

  # Generates TOML configuration snippets for local Git repositories used by Tabby.
  # Takes a list of attribute sets, where each set has 'name' and 'repo' keys.
  # Example output for one repository:
  # [[repositories]]
  # name = "my-project"
  # git_url = "file:///path/to/my-project"
  mkLocalRepositories =
    repositories:
    # Process each repository definition in the input list.
    builtins.concatStringsSep "\n" (
      # Join the results for each repo with newlines.
      map (r: ''
        [[repositories]]
        name = "${r.name}"
        git_url = "file:///${r.repo}"
      '') repositories
    );

  # Determine the appropriate device argument for Tabby based on the OS and GPU availability.
  # This tells Tabby which hardware to use for acceleration.
  deviceArg =
    if isDarwin then
      "--device metal" # Use Apple Metal on macOS.
    else if enabledNvidia then
      "--device cuda" # Use Nvidia CUDA if drivers are enabled on Linux/other.
    else
      ""; # No specific device argument if neither applies (CPU is default).

in
{
  # --- Module Options ---
  # Defines the configuration settings users can set for this module in their home.nix.
  options.${namespace}.development.ai =
    let
      # Define a default port for Ollama, used in Tabby's default model endpoints.
      defaultOllamaPort = 11000;
    in
    {
      # Standard enable/disable toggle for all features in this module.
      enable = lib.mkEnableOption "Toggle AI Development Tools (Tabby, Aider, etc.)";

      # Port for the Ollama service (primarily relevant if running Ollama via this module on macOS).
      port = mkIntOption defaultOllamaPort "Ollama Service Port (used on macOS if enabled here)";

      # Configuration specific to Tabby (AI code completion).
      tabby = {
        # Port for the Tabby server process.
        port = mkIntOption 11001 "Tabby Server Port";

        # List of local Git repositories for Tabby to index.
        localRepos = mkListOption (subModuleType {
          # Define the structure of each item in the list.
          name = mkStrOption "" "Unique name for the repository in Tabby";
          repo = mkStrOption "" "Absolute path to the local Git repository";
        }) [ ] "Local Git repositories for Tabby to index"; # Default is an empty list.

        # Configuration for the language models Tabby uses.
        model = {
          # Default configuration for the chat model.
          chat = mkAttrsOption lib.types.str {
            # Expects string values in the attribute set.
            kind = "openai/chat"; # Type of model provider.
            model_name = "qwen2.5-coder:7b-instruct"; # Specific model identifier.
            # Endpoint where the model API is available (defaults to local Ollama).
            api_endpoint = "http://localhost:${builtins.toString defaultOllamaPort}/v1";
          } "Tabby Chat Model Configuration";

          # Default configuration for the code completion model.
          completion = mkAttrsOption lib.types.str {
            kind = "ollama/completion"; # Using Ollama for completion.
            api_endpoint = "http://localhost:${builtins.toString defaultOllamaPort}";
            model_name = "qwen2.5-coder:7b-base";
            # Specific prompt format required by this model.
            prompt_template = "<|fim_prefix|> {prefix} <|fim_suffix|>{suffix} <|fim_middle|>";
          } "Tabby Completion Model Configuration";

          # Default configuration for the embedding model (used for context/retrieval).
          embedding = mkAttrsOption lib.types.str {
            kind = "ollama/embedding"; # Using Ollama for embeddings.
            model_name = "nomic-embed-text:latest";
            api_endpoint = "http://localhost:${builtins.toString defaultOllamaPort}";
          } "Tabby Embedding Model Configuration";
        };
      };
    };

  # --- Module Configuration ---
  # This section applies the actual configuration to the user's environment
  # *if* the module is enabled (moduleCfg.enable is true).
  config = lib.mkIf moduleCfg.enable {

    # Configure SOPS secrets needed for AI tools.
    # These secrets (API keys) are expected to be managed by sops-nix.
    sops = {
      secrets."openai_auth_token" = { }; # Placeholder for OpenAI API key.
      secrets."deepseek_auth_token" = { }; # Placeholder for DeepSeek API key.
      secrets."gemini_auth_token" = { }; # Placeholder for Google Gemini API key.
      secrets."groq_auth_token" = { }; # Placeholder for GROQ API key.
      secrets."tabby_auth_token" = { }; # Placeholder for Tabby server auth token (if needed).

      # Generate the Tabby Agent configuration file using a template.
      # The agent runs in the background (e.g., for IDE integration).
      templates."tabby-agent-config" = {
        # Target path for the generated config file.
        path = "${userModuleCfg.homeDir}/.tabby-client/agent/config.toml";
        # Content of the TOML file.
        content = ''
          [server]
          # Point the agent to the Tabby server configured by this module.
          endpoint = "http://localhost:${builtins.toString osMergedCfg.tabby.port}"
          # Use the auth token decrypted by sops-nix.
          token = "${config.sops.placeholder."tabby_auth_token"}"

          [logs]
          level = "info" # Set logging level.

          [anonymousUsageTracking]
          disable = true # Disable telemetry.
        '';
      };
    };

    # Home Manager specific configurations.
    home = {
      # Install necessary packages into the user's profile.
      packages =
        with pkgs; # Make packages available by their name directly.
        lib.flatten [
          # Flatten the list of lists into a single list.
          # Packages to install on all systems.
          [
            tabby # The Tabby server itself.
            tabby-agent # The Tabby agent for IDEs.
            katana # A tool potentially used with AI workflows (context needed).
            aider-chat-full # AI coding assistant CLI tool.
          ]
          # Packages to install only on Linux.
          (lib.optional isLinux [
            lmstudio # AI model runner GUI (marked broken on macOS in nixpkgs).
            # Python packages likely for local model experimentation or dependencies.
            python313Packages.peft # Parameter-Efficient Fine-Tuning library.
            python313Packages.transformers # Hugging Face Transformers library.
            python313Packages.bitsandbytes # For model quantization (running large models efficiently).
          ])
        ];

      # Create configuration files in the user's home directory.
      file =
        let
          # Convert the model configurations from attribute sets to TOML strings.
          chatModelCfg = attrsToString osMergedCfg.tabby.model.chat;
          embeddingCfg = attrsToString osMergedCfg.tabby.model.embedding;
          completionCfg = attrsToString osMergedCfg.tabby.model.completion;
        in
        {
          # Create/manage the main Tabby server configuration file.
          ".tabby/config.toml".text = ''
            # Basic server settings.
            [server]
            endpoint = "http://127.0.0.1:${builtins.toString osMergedCfg.tabby.port}"
            completion_timeout = 15000 # Timeout for code completions in milliseconds.

            # Conditionally include model configurations if they are not empty.
            # This allows users to potentially disable a model type by setting its config to {}.
            ${lib.optionalString (chatModelCfg != "") ''
              [model.chat.http]
              ${chatModelCfg}
            ''}

            ${lib.optionalString (embeddingCfg != "") ''
              [model.embedding.http]
              ${embeddingCfg}
            ''}

            ${lib.optionalString (completionCfg != "") ''
              [model.completion.http]
              ${completionCfg}
            ''}

            # Include definitions for local repositories to be indexed.
            ${mkLocalRepositories osMergedCfg.tabby.localRepos}
          '';
        };
    };

    # --- OS-Specific Service Management ---

    # On macOS, manage the Ollama service using Home Manager's `services` integration
    # if this module is responsible for it (determined by osMergedCfg.port logic).
    # Note: This assumes Ollama is *not* managed system-wide via NixOS on Darwin.
    services = lib.mkIf (isDarwin && moduleCfg.port == osMergedCfg.port) {
      ollama = {
        enable = true; # Enable the Ollama service managed by Home Manager.
        port = osMergedCfg.port; # Use the configured port.
        # Acceleration is typically handled automatically by Ollama on Darwin (Metal).
        # Setting it explicitly might be needed in some cases, but null often works.
        acceleration = null;
      };
    };

    # On Linux, define a user-level systemd service for Tabby.
    systemd.user.services.tabby = lib.mkIf isLinux {
      Unit = {
        Description = "User-level Tabby Service";
        # Ensure Ollama service (if managed by systemd, either system or user) starts first.
        # Adjust this if Ollama runs differently (e.g., container, manual start).
        After = [
          "network-online.target"
          "ollama.service"
        ];
        Requires = [ "network-online.target" ]; # Requires network to potentially fetch models/configs.
      };
      Service = {
        Type = "simple"; # Process runs in the foreground.
        # Command to start the Tabby server.
        ExecStart = ''
          ${pkgs.tabby}/bin/tabby serve \
            --port ${builtins.toString osMergedCfg.tabby.port} \
            ${deviceArg} # Add device argument (--device cuda or empty).
        '';
        Restart = "on-failure"; # Restart the service if it fails.
        RestartSec = "5s"; # Wait 5 seconds before restarting.
      };
      Install = {
        # Start the service automatically when the user logs in.
        WantedBy = [ "default.target" ];
      };
    };

    # On macOS, define a user-level launchd agent for Tabby.
    launchd.agents.tabby = lib.mkIf isDarwin {
      enable = true; # Enable the launchd agent.
      config = {
        Label = "com.tabby.serve"; # Unique identifier for the agent.
        # Command and arguments to run. Note: deviceArg logic is simplified here, explicitly using metal.
        ProgramArguments = [
          "${pkgs.tabby}/bin/tabby" # Path to the tabby executable.
          "serve" # Subcommand to start the server.
          "--port"
          (builtins.toString osMergedCfg.tabby.port) # Port argument.
          "--device"
          "metal" # Explicitly use Metal on macOS.
        ];
        RunAtLoad = true; # Start the agent immediately when it's loaded (on login).
        KeepAlive = true; # Automatically restart the agent if it crashes or exits.
        # Redirect standard output and error to log files for debugging.
        StandardOutPath = "/tmp/tabby-${config.${namespace}.user.name}.log"; # User-specific log
        StandardErrorPath = "/tmp/tabby-${config.${namespace}.user.name}.err"; # User-specific error log
      };
    };

    # --- Shell Integration ---

    # Configure Fish shell environment variables and functions.
    # This assumes the 'cli-utils.fish' module exists elsewhere in the configuration.
    ${namespace}.development.cli-utils.fish = {
      # Set environment variables available in interactive Fish sessions.
      interactiveEnvs = {
        # Make the Ollama host and port easily accessible.
        OLLAMA_HOST = "127.0.0.1:${builtins.toString osMergedCfg.port}";
      };
      # Define custom functions available in interactive Fish sessions.
      interactiveFuncs = {
        # Helper function to run 'aider' with the Gemini API key.
        gemini_aider = ''
          # Temporarily set the GEMINI_API_KEY environment variable for the aider command.
          # Reads the key from the path managed by sops-nix.
          set -lx GEMINI_API_KEY (cat ${config.sops.secrets."gemini_auth_token".path})
          # Run aider, specifying the Gemini Pro model.
          aider --model gemini-1.5-pro $argv # Pass any additional arguments ($argv) to aider
          # Unset the key after the command finishes (optional, but good practice).
          set -e GEMINI_API_KEY
        '';
      };
    };
  };

}
