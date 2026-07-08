{
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;

        withRuby = false;
        withPython3 = false;

        extraPackages = with pkgs; [
          # language servers
          lua-language-server
          nixd
          bash-language-server
          taplo
          ruff
          ty
          marksman
          yaml-language-server
          oxlint
          tofu-ls
          opentofu # tofu-ls shells out to the tofu cli

          # linters
          markdownlint-cli2
          # snapshot tests broken upstream on this pin
          (statix.overrideAttrs (_: {
            doCheck = false;
          }))
          yamllint
          editorconfig-checker
        ];
      };

      xdg.configFile."nvim/init.lua".source = ./init.lua;
      xdg.configFile."nvim/lua".source = ./lua;
    };

  flake.modules.nixos.neovim =
    { pkgs, ... }:
    {
      environment.etc."nvim/runtime".source = "${pkgs.neovim-unwrapped}/share/nvim/runtime";
    };

  flake.modules.darwin.neovim =
    { pkgs, ... }:
    {
      environment.etc."nvim/runtime".source = "${pkgs.neovim-unwrapped}/share/nvim/runtime";
    };
}
