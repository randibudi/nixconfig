let
  randibudi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIII4yhniahwSjB1OWJbK3rZdU040yhmGEAleCOnRJ2VR";
in {
  "vpn-l2tp-solusi247.age".publicKeys = [randibudi];
  "vpn-wireguard-wisecon.age".publicKeys = [randibudi];
}
