{ ... }:

{
  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
      identityFile = "~/.ssh/id_ed25519";
      extraOptions.AddKeysToAgent = "yes";
    };
  };
}
