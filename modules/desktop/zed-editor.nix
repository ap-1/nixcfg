{
  flake.modules.homeManager.zed-editor = { pkgs, ... }: {
    programs.zed-editor = {
      enable = true;
      # TODO: https://github.com/NixOS/nixpkgs/pull/584581
      package = pkgs.zed-editor.override {
        cargo-bundle = pkgs.cargo-bundle.overrideAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.pkg-config ];
          buildInputs = old.buildInputs ++ [ pkgs.aws-lc ];
        });
      };
      installRemoteServer = true;
      extensions = [
        "nix"
        "ini"
        "rainbow-csv"
        "just"
        "typst"
        "terraform"
        "swift"
        "lean4"
        "svelte"
        "toml"
        "oxc"
        "nginx"
        "discord-presence"
        "git-firefly"
        "lua"
        "make"
        "sql"
      ];
      extraPackages = with pkgs; [
        nixd
        nil
      ];
      userSettings = {
        vim_mode = true;
        base_keymap = "VSCode";
      };
    };
  };
}
