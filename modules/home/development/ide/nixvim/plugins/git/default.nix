{
  namespace,
  config,
  lib,
  ...
}:
let
  cfg = config.${namespace}.development.ide.nixvim.plugins.git;
  inherit (lib.${namespace}.nixvim) mkKeymap;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.${namespace}.development.ide.nixvim.plugins.git = {
    enable = mkEnableOption "Enable git plugins";
  };
  config = mkIf cfg.enable {
    programs.nixvim.plugins = {
      lazygit = {
        enable = true;
      };
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol"; # eol | overlay | right_align
            delay = 200;
          };
          current_line_blame_formatter = "   <author>, <committer_time:%R> • <summary>";
          trouble = true;
        };
      };
    };
    programs.nixvim.keymaps = [
      (mkKeymap "<leader>gd" "<cmd>Gitsigns diffthis<cr>" "Git Diff")
      (mkKeymap "[g" "<cmd>Gitsigns prev_hunk<cr>" "Prev Hunk")
      (mkKeymap "]g" "<cmd>Gitsigns next_hunk<cr>" "Next Hunk")
      (mkKeymap "<leader>ga" "<cmd>Gitsigns stage_hunk<cr>" "Stage Hunk")
      (mkKeymap "<leader>gA" "<cmd>Gitsigns undo_stage_hunk<cr>" "Undo Stage Hunk")
      (mkKeymap "<leader>gg" "<cmd>Lazygit<cr>" "Lazygit")
    ];
  };
}
