# Architecture

This config follows the [dendritic pattern](https://github.com/mightyiam/dendritic). It is a [flake-parts](https://flake.parts/) flake in which every `.nix` file in the `modules/` tree is a self-contained module, recursively imported by [`import-tree`](https://github.com/vic/import-tree). A file's path names the feature it implements and has no effect on evaluation, so files are grouped into topic directories.

## Layout

- `common/` and `desktop/` hold feature modules grouped by scope. `common/` applies to every host, `desktop/` to the graphical hosts. Each defines a `flake.modules.{nixos,homeManager,darwin}.<name>`.
- `affogato/`, `mocha/` and `cortado/` hold the modules specific to one host, plus that host's `system.nix`.
- `roles/` bundle those modules under a name (`common`, `desktop`, and one per host) for a configuration to import.
- `data/` hold flake-level data registries, read elsewhere via `config.flake.*`.

## Composition

`flake.nix` calls `mkFlake` with two imports. `flake-parts.flakeModules.modules` provides the `flake.modules.<class>.<name>` option, and `import-tree ./modules` pulls every module file into that single evaluation. Each file then contributes one part of the flake:

- feature modules and roles populate `flake.modules.{nixos,homeManager,darwin}`; a role is a module whose `imports` reference other modules as `config.flake.modules.<class>.<name>`.
- data files set `flake.{meta,hosts,services}`, readable from any module through `config.flake.*`.
- a host's `system.nix` calls `nixosSystem` or `darwinSystem` to build its `flake.{nixos,darwin}Configurations.<host>` output from the bundles it needs (its host role, `common`, and `desktop` on graphical hosts) plus flake inputs such as agenix and home-manager.

## Hosts

- `affogato` is the public NixOS VPS, running the services behind Caddy.
- `mocha` is the NixOS desktop.
- `cortado` is the nix-darwin laptop.

All three join the self-hosted [tailnet](networking.md).

## Sync

mocha and cortado share `~/Projects` and `~/.omp` over [Syncthing](https://syncthing.net/), running peer-to-peer across the tailnet and addressing each other by tailnet IP. Per-folder `.stignore` patterns, declared in Nix, exclude build artifacts such as `target/` and `node_modules/`.

Per-host hardware is in [hosts](hosts.md).

## Exposure

Services are reached one of two ways:

- Public services resolve through Cloudflare to affogato at `<name>.anish.land` and are served by affogato's Caddy under per-name ACME certificates.
- Tailnet services resolve through the mesh's MagicDNS to their host at `<name>.ts.anish.land` and are served by that host's Caddy under one `*.ts.anish.land` ACME certificate.

Both certificates are issued over the Cloudflare DNS-01 challenge, and OIDC-gated services authenticate against [kanidm](https://kanidm.com/). See [services](services.md) for the registry that drives both.

## Persistence

affogato's root filesystem is a tmpfs, recreated empty on every boot; only the `/nix` and `/persist` btrfs subvolumes survive. State is carried across reboots by the [preservation](https://github.com/nix-community/preservation) module, which restores a fixed set of paths from `/persist`. These cover service state under `/var/lib`, systemd and nixos state, machine identity (`/etc/machine-id` and the SSH host keys), logs, and the `anish` home. Anything outside that set does not survive a reboot. mocha and cortado use ordinary persistent root filesystems.

## Deploying

Each host is built locally with `nh os switch ~/nixcfg` (aliased to `update`).
