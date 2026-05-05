{inputs, ...}: {
  imports = [inputs.textfox.homeManagerModules.default];

  programs.firefox.configPath = ".mozilla/firefox";

  textfox = {
    enable = true;
    profiles = ["default"];
  };
}
