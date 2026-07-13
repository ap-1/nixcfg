{ ... }:
{
  flake.modules.homeManager.mailvelope-gnupg =
    { pkgs, ... }:
    let
      # nixpkgs builds gpgme with --enable-fixed-path at the gnupg bindir, so this makes gpgme-json use gpg-sq
      gpgme = (pkgs.gpgme.override { gnupg = pkgs.sequoia-chameleon-gnupg; }).overrideAttrs (_: {
        doCheck = false;
      });

      manifest = pkgs.writeText "gpgmejson.json" (builtins.toJSON {
        name = "gpgmejson";
        description = "JavaScript binding for GnuPG";
        path = "${gpgme.dev}/bin/gpgme-json";
        type = "stdio";
        allowed_extensions = [ "jid1-AQqSMBYb0a8ADg@jetpack" ];
      });

      hostsDir =
        if pkgs.stdenv.isDarwin then
          "Library/Application Support/Mozilla/NativeMessagingHosts"
        else
          ".mozilla/native-messaging-hosts";
    in
    {
      home.file."${hostsDir}/gpgmejson.json".source = manifest;
    };
}
