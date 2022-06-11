# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ../modules/k3s/arm64-agent.nix
      ../modules/raspberry-pi.nix
      ../modules/main-config.nix
      ../modules/sops.nix
    ];

  networking.hostName = "leaf01";

  nix.gc.dates = "Tue 02:00";

  system.autoUpgrade.dates = "Tue 04:00";

  sops.secrets.password.sopsFile = ./user/leaf01.yaml;
  sops.secrets.password.neededForUsers = true;
#  users.users.ascii.passwordFile = config.sops.secrets.password.path;
}