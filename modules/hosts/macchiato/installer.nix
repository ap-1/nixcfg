{ config, inputs, ... }:
let
  macchiato = config.flake.nixosConfigurations.macchiato.config.system.build.toplevel;
in
{
  flake.images.macchiato-installer = inputs.nixos-apple-silicon.lib.mkInstallerBootstrapCustom {
    system = "aarch64-linux";
    extraModules = [
      (
        { pkgs, ... }:
        {
          isoImage.storeContents = [ macchiato ];
          environment.etc."macchiato-system".text = "${macchiato}"; # nixos-install --system "$(cat /etc/macchiato-system)"

          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
          environment.systemPackages = [ pkgs.git ];
        }
      )
    ];
  };
}
