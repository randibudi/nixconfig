{
  inputs,
  pkgs,
  ...
}: {
  imports = [(inputs.import-tree ../../modules/home-manager)];

  programs.home-manager.enable = true;

  home = {
    username = "randibudi";
    homeDirectory = "/home/randibudi";
    packages = with pkgs; [
      antigravity-fhs
      google-chrome
      keepassxc
      nodejs_22
    ];
  };
}
