{ ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      adjust-open = "best-fit";
      pages-per-row = "1";
      zoom-min = "10";
      guioptions = "";
      scroll-page-aware = "true";
      scroll-full-overlap = "0.01";
      scroll-step = "100";
    };
  };
}
