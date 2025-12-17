{pkgs, config, ...}: {
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-l2tp
    ];
  };

  services.strongswan.enable = true;
  environment.etc."strongswan.conf".text = "";

  age.secrets.vpn-l2tp-solusi247 = {
    file = ../../secrets/vpn-l2tp-solusi247.age;
    path = "/etc/NetworkManager/system-connections/Solusi247.nmconnection";
    mode = "600";
    owner = "root";
    group = "root";
  };
}
