{
  flake.modules.nixos.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nh
        ragenix
        ghostty.terminfo # for ssh from cortado
        jq
      ];
    };

  flake.modules.darwin.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nh
        ragenix
        # foot.terminfo # for ssh from mocha
      ];
    };
}
