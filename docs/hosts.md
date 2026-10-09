# Hosts

## mocha

mocha is the desktop, an mATX AMD build comprising:

- AMD Ryzen 9 9950X (16 cores, 32 threads)
- PowerColor Hellhound Radeon RX 7800 XT (16 GB VRAM)
- Klevv CRAS V 64 GB DDR5-6400 CL32 (2 * 32 GB)
- Klevv CRAS C910 2 TB NVMe SSD (PCIe 4.0 x4)
- MSI PRO B650M-A WiFi motherboard
- EDUP BE9300 WiFi 7 card (MediaTek MT7927)
- Thermalright Peerless Assassin 120 SE cooler
- 7 Thermalright TL-C12C-S 120 mm fans
- ADATA XPG Core Reactor II 750 W power supply
- Lian Li A3-mATX case

The Zen 5 CPU runs an LTO, znver4-tuned [CachyOS kernel](https://github.com/CachyOS/linux-cachyos) (`linuxPackages-cachyos-latest-lto-zen4`) from the [`nix-cachyos-kernel`](https://github.com/xddxdd/nix-cachyos-kernel) overlay.

The EDUP card's Bluetooth firmware is not in `linux-firmware`, so the blob is vendored alongside the networking module.

Memory management uses a 32 GB swap partition with zswap (40% pool, zstd) and earlyoom.

## affogato

affogato is a [Hetzner Cloud](https://www.hetzner.com/cloud) cost-optimized x86 VPS in Nuremberg (nbg1), with an AMD EPYC processor (4 vCPU), 8 GB of RAM, around 80 GB of disk, a 4 GB swap partition, and zswap (25% pool, zstd). OOM is handled by systemd-oomd. Its root filesystem is ephemeral ([persistence](architecture.md#persistence)).

## cortado

cortado is a 14-inch MacBook Pro (Mac15,6) with an Apple M3 Pro (12 cores, 6 performance and 6 efficiency), 36 GB of RAM, and a 1 TB SSD.
