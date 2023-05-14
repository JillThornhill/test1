{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.disko.url = github:nix-community/disko;
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, disko, ... }@attrs: {
    nixosConfigurations.hetzner-cloud = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ({modulesPath, ... }: {
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            (modulesPath + "/profiles/qemu-guest.nix")
            disko.nixosModules.disko
          ];
          disko.devices = import ./disk-config.nix {
            lib = nixpkgs.lib;
          };
          boot.loader.grub = {
            devices = [ "/dev/sda" ];
            efiSupport = true;
            efiInstallAsRemovable = true;
          };
          services.openssh.enable = true;

          users.users.root.openssh.authorizedKeys.keys = [
            # change this to your ssh key
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKREKbihvckSohdmjQFZELhNNhSHdaoO9zPUUUCll9Y0 jill@Ubuntu"
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGmiq2Uxn+FeIYpDml+xhlxeHm1dGm8d1VbFfsrdTUmq root@ubuntu-4gb-hel1-3"
          ];
        })
      ];
    };
  };
}
