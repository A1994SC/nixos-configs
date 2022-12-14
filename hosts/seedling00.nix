{ config, lib, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/modules/main-config.nix
      /etc/nixos/modules/bare.nix
      /etc/nixos/modules/tailscale.nix
      /etc/nixos/modules/sops.nix
      /etc/nixos/modules/docker.nix
      /etc/nixos/modules/compose/watchtower.nix
      /etc/nixos/modules/compose/pihole-sync-trunk.nix
    ];

  networking.hostName = "seedling00";

  nix.gc.dates = "Mon 02:00";

  system.autoUpgrade.dates = "Mon 04:00";

  networking.interfaces.eth0.ipv4.addresses = [ {
    address = "10.2.1.6";
    prefixLength = 24;
  } ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  security.acme.certs."10.2.1.6" = {
    domain = "10.2.1.6";
    reloadServices = [
      "config.services.nginx"
    ];
  };

  services.nginx = {
    enable = true;
    virtualHosts."10.2.1.6" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true; # needed if you need to use WebSocket
        extraConfig =
          "proxy_ssl_server_name on;" +
          "proxy_pass_header Authorization;";
      };
    };
  };
}
