let
  anish = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwjDM2gTgro+aN81I65BFexfLXq1u/8AJ3PmCTX5X/a i@anish.land";

  macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN58RgxMAtPo7du0WeUKvhSx05rcBHqSHI9M0txrvsV8";
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFBu43o7nsVIt9KB1hpc+vCEY1CkROhQ01ZulhwtEs2j root@ap-1";

  all = [
    anish
    macbook
    pc
  ];
in
{
  "secrets/homepage-dashboard.age".publicKeys = all;
  "secrets/transmission.age".publicKeys = all;
  "secrets/vaultwarden.age".publicKeys = all;
}
