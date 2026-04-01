{
  description = "My NixOs Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:youwen5/zen-browser-flake";
    stylix.url = "github:nix-community/stylix";
    sops-nix.url = "github:Mic92/sops-nix";
    dotfiles = {
      url = "git+ssh://git@github.com/leehosanganson/dotfiles.git";
      flake = false;
    };
    secrets = {
      url = "git+ssh://git@github.com/leehosanganson/sops.git";
      flake = false;
    };
  };
  outputs = { nixpkgs, home-manager, sops-nix, dotfiles, secrets, ... }@inputs: {
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
            dotfilesPath = dotfiles;
            secretsPath = secrets;
          };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
        }
      ];
    };
    homeConfigurations."ansonlee@mac-mini" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      extraSpecialArgs = { inherit inputs; dotfilesPath = dotfiles; secretsPath = secrets; };
      modules = [
        ./hosts/mac-mini/home.nix
        sops-nix.homeManagerModules.sops
      ];
    };
    homeConfigurations."vscode@devcontainer" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      extraSpecialArgs = { inherit inputs; dotfilesPath = dotfiles; secretsPath = secrets; };
      modules = [
        ./hosts/devcontainer/home.nix
        sops-nix.homeManagerModules.sops
      ];
    };
  };
}
