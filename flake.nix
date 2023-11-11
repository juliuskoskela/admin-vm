{
  description = "NixOS in MicroVMs";

  inputs.microvm.url = "github:astro/microvm.nix";
  inputs.microvm.inputs.nixpkgs.follows = "nixpkgs";

  outputs = {
    self,
    nixpkgs,
    microvm,
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.admin-vm = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        microvm.nixosModules.microvm
        (import ./admin-vm.nix)
      ];
    };

    packages.${system}.admin-vm = self.nixosConfigurations.admin-vm.config.microvm.declaredRunner;
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {};
  };
}
