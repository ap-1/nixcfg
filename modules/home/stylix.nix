{ pkgs, ... }:

{
  stylix = {
    enable = true;
    autoEnable = false;

    cursor = {
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 24;
    };
  };
}
