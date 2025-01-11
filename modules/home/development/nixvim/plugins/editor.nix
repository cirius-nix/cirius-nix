{
  render-markdown = {
    enable = true;
    settings = { };
  };
  undotree = {
    enable = true;
    settings = {
      AutoOpenDiff = true;
      FocusOnToggle = true;
      CursorLine = true;
      DiffAutoOpen = true;
      DiffCommand = "diff";
      DiffpanelHeight = 10;
      HelpLine = true;
      HighlightChangedText = true;
      HighlightChangedWithSign = true;
      HighlightSyntaxAdd = "DiffAdd";
      HighlightSyntaxChange = "DiffChange";
      HighlightSyntaxDel = "DiffDelete";
      RelativeTimestamp = true;
      SetFocusWhenToggle = true;
      ShortIndicators = false;
      TreeNodeShape = "*";
      TreeReturnShape = "\\";
      TreeSplitShape = "/";
      TreeVertShape = "|";
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
