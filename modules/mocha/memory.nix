{
  flake.modules.nixos.mocha-memory = { ... }: {
    boot.kernelParams = [
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.zpool=zsmalloc"
      "zswap.max_pool_percent=40"
    ];

    boot.kernel.sysctl = {
      "vm.swappiness" = 100;
    };

    services.earlyoom.enable = true;

    # TODO: raise to 64G
    systemd.slices."system-nix\\x2ddaemon".sliceConfig.MemoryHigh = "40G";
  };
}
