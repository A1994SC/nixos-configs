{ config, pkgs, lib, ... }:

{
  sops.secrets = {
    pihole = {
      sopsFile = /etc/nixos/modules/compose/secrets/seedling/pihole.yaml;
      mode = "0644";
    };
    "id_ed25519" = {
      sopsFile = /etc/nixos/modules/compose/secrets/seedling/pihole.yaml;
      mode = "0600";
      key = "sync";
    };
    "id_ed25519.pub" = {
      sopsFile = /etc/nixos/modules/compose/secrets/seedling/pihole.yaml;
      mode = "0644";
      key = "sync-pub";
    };
  };

  systemd.services."docker-compose@pihole-sync-trunk" = {
    enable = true;
    unitConfig = {
      Description = "%i service with docker compose";
      PartOf = "docker.service";
      After = "docker.service";
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/etc/nixos/compose/%i";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d --remove-orphans";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
    };
  };
}