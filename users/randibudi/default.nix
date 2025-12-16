{inputs, ...}: {
  imports = [(inputs.import-tree ../../modules/home-manager)];

  home = {
    username = "randibudi";
    homeDirectory = "/home/randibudi";
  };

  programs.home-manager.enable = true;
}
