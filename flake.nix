{
	description = "My shitty NixOS configuration";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		home-manager = {
			url = "github:nix-community/home-manager/release-25.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }: 
	let
		pkgs = nixpkgs.legacyPackages."x86_64-linux";
		pkgs-unstable = nixpkgs-unstable.legacyPackages."x86_64-linux";
	in {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.zynith = import ./home.nix;
						backupFileExtension = "backup";
					};
				}
			];
			specialArgs = {
				inherit pkgs-unstable;
			};
		};
	};
}
