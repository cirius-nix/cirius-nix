{ ... }:
{
  nixvim = {
    mkEnabled = {
      enable = true;
    };
    mkDisabled = {
      enable = false;
    };
    mkRaw = rawContent: {
      __raw = rawContent;
    };
    mkKeymap =
      key: action: opts:
      let
        defaultOptions = {
          nowait = true;
          noremap = true;
          silent = true;
        };

        options =
          if opts == null then
            defaultOptions
          else if builtins.isString opts then
            defaultOptions // { desc = opts; }
          else if builtins.isAttrs opts && opts ? options then
            opts.options
          else
            defaultOptions;

        mode =
          if builtins.isAttrs opts && opts ? mode && builtins.isList opts.mode then opts.mode else [ "n" ];
      in
      {
        mode = mode;
        key = key;
        action = action;
        options = options;
      };
  };
}
