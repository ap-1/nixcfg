{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      packages = [
        pkgs.opentofu
        pkgs.rage
      ];

      shellHook = ''
        set -a
        eval "$(rage -d -i ~/.ssh/id_ed25519 ${inputs.self}/secrets/opentofu.age)"
        set +a
        export AWS_SHARED_CREDENTIALS_FILE=/dev/null
        export AWS_CONFIG_FILE=/dev/null
        export AWS_EC2_METADATA_DISABLED=true
      '';
    };
  };
}
