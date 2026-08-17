{
  description = "nixos-config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = inputs@{ self, nixpkgs, home-manager, nixpkgs-unstable, ... }: {
    nixosConfigurations.pixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit inputs; }; 
      
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.pilot = import ./home.nix;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit inputs; };
          };
        }
      ];
    };
  };
}
