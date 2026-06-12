{
  # required by preservation
  boot.initrd.systemd.enable = true;

  preservation = {
    enable = true;
    preserveAt."/persist" = {
      directories = [
        "/var/log"
        "/var/lib/systemd"
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
      ];
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key.pub";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_rsa_key";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_rsa_key.pub";
          how = "symlink";
          configureParent = true;
        }
      ];
      users.anish = {
        directories = [
          {
            directory = ".ssh";
            mode = "0700";
          }
        ];
        files = [
          ".zsh_history"
        ];
      };
    };
  };

  # preservation owns /etc/machine-id
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
}
