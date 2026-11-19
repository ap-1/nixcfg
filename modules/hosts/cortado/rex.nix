{ inputs, ... }:
{
  flake.modules.homeManager.rex = {
    imports = [ inputs.rex.homeManagerModules.default ];

    programs.rex.enable = true;
  };
}
