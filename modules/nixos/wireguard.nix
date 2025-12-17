{
  config,
  pkgs,
  ...
}: {
  age.secrets.wireguard-private.file = ../../secrets/wireguard-private.age;

  environment.systemPackages = [pkgs.wireguard-tools];

  networking.wg-quick.interfaces = {
    # VPN connection for Wisesa Consulting Indonesia
    wg0 = let
      # Server public key
      publicKey = "nGEjPPB0CcVb/CABkRWLViT6gPNwp0hgsYbEGHt+D3M=";
    in {
      address = ["10.100.0.75/32"];
      mtu = 1280;
      # Client public key: ZaGWjAFLSvYzHpcLvunJDASGNOK6jXAcXDG2vudcK1Y=
      privateKeyFile = config.age.secrets.wireguard-private.path;
      postUp = ["${pkgs.wireguard-tools}/bin/wg set wg0 peer ${publicKey} persistent-keepalive 25"];
      peers = [
        {
          inherit publicKey;
          allowedIPs = ["10.100.0.0/24" "192.168.20.0/24"];
          endpoint = "103.93.130.199:51820";
        }
      ];
    };
  };

  networking.firewall = {
    allowedUDPPorts = [51820];
    checkReversePath = "loose";
  };
}
