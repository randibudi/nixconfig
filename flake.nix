{
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    textfox = {
      url = "github:adriankarlen/textfox";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}: let
    stateVersion = "25.11";
  in
    flake-parts.lib.mkFlake {inherit inputs;} ({withSystem, ...}: {
      imports = [
        inputs.home-manager.flakeModules.home-manager
        inputs.git-hooks-nix.flakeModule
      ];

      systems = ["x86_64-linux"];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        formatter = pkgs.alejandra;
        pre-commit = {
          settings.hooks.alejandra.enable = true;
          settings.excludes = ["flake.lock"];
        };
      };

      flake = {
        nixosModules.default = {pkgs, ...}: {
          nix.settings = {
            experimental-features = ["nix-command" "flakes"];
            warn-dirty = false;
            extra-substituters = [
              "https://hercules-ci.cachix.org"
              "https://nix-community.cachix.org"
              "https://pre-commit-hooks.cachix.org"
            ];
            extra-trusted-public-keys = [
              "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
            ];
          };
          environment.systemPackages = [inputs.agenix.packages.${pkgs.system}.default];
          age.identityPaths = ["/home/randibudi/.ssh/id_ed25519"];
          system.stateVersion = stateVersion;
        };

        nixosConfigurations = {
          denali = withSystem "x86_64-linux" ({
            pkgs,
            system,
            ...
          }:
            inputs.nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {inherit inputs pkgs;};
              modules = [
                inputs.self.nixosModules.default
                inputs.agenix.nixosModules.default
                (inputs.import-tree ./hosts/denali)
              ];
            });
        };

        homeConfigurations = {
          randibudi = withSystem "x86_64-linux" ({pkgs, ...}:
            inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = {inherit inputs;};
              modules = [
                ./users/randibudi
                inputs.agenix.homeManagerModules.default
                {home.stateVersion = stateVersion;}
              ];
            });
        };
      };
    });
}
