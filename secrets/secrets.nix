let
  randibudi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIK14V26VEvwRFT6fU5VAS45kRRABjj5EBdSuVCRc8C9 hi@randibudi.dev";
in {
  "wireguard-private.age".publicKeys = [randibudi];
}
