{
  flake.meta = rec {
    name = "Anish Pallati";
    email = "i@anish.land";
    sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwjDM2gTgro+aN81I65BFexfLXq1u/8AJ3PmCTX5X/a i@anish.land";

    domain = "anish.land";
    tailnetDomain = "ts.${domain}";
    idpDomain = "idp.${domain}";
    idpUrl = "https://${idpDomain}";
  };
}
