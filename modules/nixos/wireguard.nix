{pkgs, ...}: {
  environment.systemPackages = [pkgs.wireguard-tools];

  age.secrets.vpn-wireguard-wisecon = {
    file = ../../secrets/vpn-wireguard-wisecon.age;
    path = "/etc/NetworkManager/system-connections/Wisecon.nmconnection";
    mode = "600";
    owner = "root";
    group = "root";
  };
}
