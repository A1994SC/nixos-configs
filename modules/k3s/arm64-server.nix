{ config, pkgs, lib, ... }:

{
  imports = [
    ./.
    /etc/nixos/modules/k3s/service-server.nix
  ];

  nixpkgs.overlays = [
    (self: super: {
      k3s = super.callPackage /etc/nixos/pkgs/k3s-arm64.nix {};
    })
  ];
}
