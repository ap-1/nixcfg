# Secrets

Secrets are age files decrypted on system activation by the [agenix](https://github.com/ryantm/agenix) module and edited with the [ragenix](https://github.com/yaxitech/ragenix) CLI.

Each secret declares which public keys may decrypt it, drawn from the owner key (`anish`) and the host keys in the `flake.meta` and `flake.hosts` registries. A secret scoped to one host is readable only by `anish` and that host, while a shared secret is readable by every host.

A module declares each secret it needs and reads the decrypted value from `config.age.secrets.<name>.path`, which agenix populates under `/run/agenix` on activation. Decryption depends on the activating host's key being among that secret's recipients.
