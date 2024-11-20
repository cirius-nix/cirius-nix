{
  undotree = {
    enable = true;
    settings = {
      autoOpenDiff = true;
      focusOnToggle = true;
    };
  };
  treesitter = {
    enable = true;
  };
  mini = {
    enable = true;
    modules = {
      comment = { };
      pairs = { };
    };
  };
  nvim-tree = {
    enable = true;
    syncRootWithCwd = true;
    respectBufCwd = true;
    updateFocusedFile = {
      enable = true;
      updateRoot = false;
    };
    renderer.icons.gitPlacement = "after";
    diagnostics.enable = true;
  };
}
