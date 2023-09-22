{
  description = "Dev Environment";

  inputs.dsf.url          = "github:cruel-intentions/devshell-files";
  inputs.nixpkgs.url      = "github:nixos/nixpkgs";
  inputs.nimblelock.url   = "github:riinr/cascli?shallow=1";
  inputs.nimblelock.flake = false;
  inputs.dsf.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs:
  let
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux.extend (final: prev: {
      nim           = final.nim2;
      nimbleLock    = builtins.fromJSON (builtins.readFile "${inputs.nimblelock}/nimble.lock");
      cassandra-nim = final.callPackage ./cassandra-nim-wrapper.nix {};
    });
  in
  {
    packages.x86_64-linux.cas-nim = pkgs.cassandra-nim;
    packages.x86_64-linux.default = pkgs.callPackage ./default.nix {};
    packages.x86_64-linux.cascli  = pkgs.callPackage ./default.nix { lsb = true; };
  } //
  inputs.dsf.lib.shell inputs [
    ./project.nix  # import nix module
  ];
}
