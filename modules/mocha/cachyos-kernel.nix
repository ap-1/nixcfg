{ inputs, ... }:
{
  flake.modules.nixos.cachyos-kernel =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [
        inputs.nix-cachyos-kernel.overlays.pinned
      ];
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;

      nix.settings = {
        substituters = [
          "https://attic.xuyh0120.win/lantian"
        ];
        trusted-public-keys = [
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        ];
      };
    };
}
