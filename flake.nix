{
  description = "My NixOs Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:youwen5/zen-browser-flake";
    stylix.url = "github:nix-community/stylix";
    sops-nix.url = "github:Mic92/sops-nix";
    secrets = {
      url = "git+ssh://git@github.com/leehosanganson/sops.git";
      flake = false;
    };
  };
  outputs = { nixpkgs, home-manager, nix-darwin, secrets, ... }@inputs: {
    nixosConfigurations.lhs-desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/lhs-desktop
        inputs.stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.ansonlee = ./hosts/lhs-desktop/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            secretsPath = secrets;
          };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
        }
      ];
    };
    darwinConfigurations."mac-mini" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs; secretsPath = secrets; };
      modules = [
        ./hosts/mac-mini
        home-manager.darwinModules.home-manager
        {
          home-manager.users.ansonlee = ./hosts/mac-mini/home.nix;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.extraSpecialArgs = { inherit inputs; secretsPath = secrets; };
        }
      ];
    };
    darwinConfigurations."lhs-mbp" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs; secretsPath = secrets; };
      modules = [
        ./hosts/lhs-mbp
        home-manager.darwinModules.home-manager
        {
          home-manager.users.ansonlee = ./hosts/lhs-mbp/home.nix;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.extraSpecialArgs = { inherit inputs; secretsPath = secrets; };
        }
        {
          nixpkgs.overlays = [
            (final: prev: { direnv = prev.direnv.overrideAttrs (old: { doCheck = false; }); })
          ];
        }
      ];
    };
  };
}
