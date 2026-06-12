{
  flake.modules.nixos.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nh
        ghostty.terminfo # for ssh from cortado
      ];
    };

  flake.modules.darwin.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nh
        # foot.terminfo # for ssh from mocha
      ];
    };
}
