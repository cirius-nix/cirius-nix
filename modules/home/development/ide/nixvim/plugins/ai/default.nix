{
  namespace,
  lib,
  config,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim.plugins.ai;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.${namespace}.development.ide.nixvim.plugins.ai = {
    enable = mkEnableOption "Enable AI plugins for NixVim";
    ollamaModel = lib.mkOption {
      description = "Model to use";
      default = "qwen2.5-coder:latest";
      type = lib.types.str;
    };
    ollamaHost =
      lib.${namespace}.mkStrOption "http://127.0.0.1:11234"
        "Host address of the Ollama server";
  };
  config = mkIf cfg.enable {
    programs.nixvim.plugins = {
      ollama = {
        enable = true;
        model = cfg.ollamaModel;
        url = cfg.ollamaHost;
      };
      codecompanion = {
        enable = true;
        settings = {
          adapters = {
            ollama = {
              __raw = ''
                function()
                  return require('codecompanion.adapters').extend('ollama', {
                      env = {
                          url = cfg.ollamaHost,
                      },
                      schema = {
                          model = {
                              default = cfg.ollamaModel,
                          },
                          num_ctx = {
                              default = 32768,
                          },
                      },
                  })
                end
              '';
            };
          };
          display = {
            action_palette = {
              opts = {
                show_default_prompt_library = true;
              };
              provider = "default";
            };
            chat = {
              window = {
                layout = "vertical";
                opts = {
                  breakindent = true;
                };
              };
            };
          };
          opts = {
            log_level = "TRACE";
            send_code = true;
            use_default_actions = true;
            use_default_prompts = true;
          };
          strategies = {
            agent = {
              adapter = "ollama";
            };
            chat = {
              adapter = "ollama";
            };
            inline = {
              adapter = "ollama";
            };
          };
        };
      };
      cmp-ai = {
        enable = true;
        settings = {
          provider = "Ollama";
          run_on_every_key_stroke = true;
          provider_options = {
            __raw = ''
              {
                model = "${cfg.ollamaModel}",
                prompt = function(lines_before, lines_after)
                  return lines_before
                end,
                suffix = function(lines_after)
                  return lines_after
                end,
                auto_unload = false,
              }
            '';
          };
        };
      };
    };
  };
}
