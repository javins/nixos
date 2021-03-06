# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "usbhid" "usb_storage" ];

  boot.kernelModules = [
    "applesmc" # apple system managment controller, regulates fan and other hw goodies
    "coretemp" # recommended by lm-sensors, apparently present already, but I con't figure out what was loading it
    "brcmsmac" # wireless
    "kvm-intel" # for nix containers
  ];

  boot.blacklistedKernelModules = [
    # Macbooks don't have PS2 capabilities, and the I8042 driver spams an err like
    # the following on boot:
    #
    # Dec 26 09:43:17 nix kernel: i8042: No controller found
    #
    # This is harmless, but it is noise in the logs when I'm looking for real errors.
    #
    # Alas atkbd was built into nixpkgs here:
    #
    # https://github.com/NixOS/nixpkgs/commit/1c22734cd2e67842090f5d59a6c7b2fb39c1cf66
    #
    # so there isn't a good way to remove it from boot.kernelModules. Thus blacklisting.
    "atkbd"
  ];

  # Bluetooth support seemed busted as of 2015-12-26
  # journalctl was turning up messages like the follwoing every boot:
  #
  # Dec 26 09:11:34 nix bluetoothd[511]: Parsing /nix/store/sd154zk2qfxqd3rsbwimnaqpsca1hflg-bluez-4.101/etc/bluetooth/input.conf failed: No such file or directory
  # Dec 26 09:11:34 nix bluetoothd[511]: Parsing /nix/store/sd154zk2qfxqd3rsbwimnaqpsca1hflg-bluez-4.101/etc/bluetooth/audio.conf failed: No such file or directory
  # Dec 26 09:11:34 nix bluetoothd[511]: Parsing /nix/store/sd154zk2qfxqd3rsbwimnaqpsca1hflg-bluez-4.101/etc/bluetooth/serial.conf failed: No such file or directory
  # Dec 26 09:11:34 nix bluetoothd[511]: Unknown command complete for opcode 19
  hardware.bluetooth.enable = false;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nix.maxJobs = 4;
}
