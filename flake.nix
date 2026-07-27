{
  description = "nixos-config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    hyprland.url = "github:hyprwm/HYprland/v0.55.0";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # oxwm = {
    #   url = "github:tonybanters/oxwm";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
  
  outputs = { self, nixpkgs, home-manager, hyprland, ... }: {
    nixosConfigurations.pixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
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
          };
        }
        # oxwm.nixosModules.default
        # {
        #   services.xserver = {
        #     enable = true;
        #     windowManager.oxwm.enable = true;
        #   };
        # }
      ];
    };
  };
}
