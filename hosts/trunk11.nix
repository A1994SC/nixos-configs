# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ 
#      ../modules/k3s/amd64-server.nix
      ../modules/qemu.nix
      ../modules/main-config.nix
      ../modules/sops.nix
    ];

  networking.hostName = "trunk11";

  nix.gc.dates = "Tue 02:00";

  system.autoUpgrade.dates = "Tue 04:00";

  #FIXME: Added manually because it wasn't respecting "main-config.nix" creatation of 'ascii'
  users.users.ascii = {
    isNormalUser = true;
    extraGroups  = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILTN+22xUz/NIZ/+E3B7bSQAl1Opxg0N7jIVGlAxTJw2"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpoTjm581SSJi51VuyDXkGj+JThQOavxicFgK1Z/YlN"
    ];
  };
}