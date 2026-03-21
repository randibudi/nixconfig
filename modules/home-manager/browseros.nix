{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [inputs.browseros.overlays.default];

  home.packages = [pkgs.browseros-ai];
}
