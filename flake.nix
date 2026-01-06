{
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
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
      };

      flake = {
        nixosModules.default = {pkgs, ...}: {
          nix.settings = {
            experimental-features = ["nix-command" "flakes"];
            warn-dirty = false;
            extra-substituters = [
              "https://hercules-ci.cachix.org"
              "https://nix-community.cachix.org"
            ];
            extra-trusted-public-keys = [
              "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];
          };
          environment.systemPackages = [inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default];
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
                ./users/randibudi.nix
                inputs.agenix.homeManagerModules.default
                {home.stateVersion = stateVersion;}
              ];
            });
        };
      };
    });
}
