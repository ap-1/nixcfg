{
  flake.modules.nixos.memory = { ... }: {
    zramSwap = {
      enable = true;
      memoryPercent = 100;
    };
    services.earlyoom.enable = true;

    # Copied from Pop!_OS
    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
  };
}
