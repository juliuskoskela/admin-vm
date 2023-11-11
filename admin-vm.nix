{
  pkgs,
  lib,
  config,
  ...
}: {
  microvm = {
    hypervisor = "crosvm";

    shares = [
      {
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
    ];

    interfaces = [
      {
        type = "tap";
        id = "tap0";
        mac = "02:00:00:00:00:01";
      }
    ];

    socket = "control.socket";
  };

  networking.hostName = "admin-vm";

  systemd.network.enable = true;

  systemd.network.networks."20-lan" = {
    matchConfig.Type = "ether";
    networkConfig = {
      Address = ["192.168.1.3/24" "2001:db8::b/64"];
      Gateway = "192.168.1.1";
      DNS = ["192.168.1.1"];
      IPv6AcceptRA = true;
      DHCP = "no";
    };
  };

  users.users.root.password = "root";

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = config.system.nixos.version;
}
