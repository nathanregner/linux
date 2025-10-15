{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {
      devShells.x86_64-linux.default =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          inherit (pkgs) lib;
          pkgsCross = pkgs.pkgsCross.aarch64-multiplatform;
        in
        pkgsCross.mkShell {
          env = {
            ARCH = pkgsCross.stdenv.hostPlatform.linuxArch;
            CROSS_COMPILE = pkgsCross.stdenv.cc.targetPrefix;
            PKG_CONFIG_PATH = lib.concatStringsSep ":" [
              "${pkgs.ncurses.dev}/lib/pkgconfig"
              "${pkgs.openssl.dev}/lib/pkgconfig"
            ];
          };
          # mkdir build
          # make O=build nconfig
          # make O=build -j12
          shellHook = ''
            alias make="make -j$NIX_BUILD_CORES"
          '';
          packages = [
            pkgs.bc
            pkgs.bison
            pkgs.flex
            pkgs.pkg-config
            pkgs.stdenv.cc
            pkgs.ubootTools
          ];
        };
    };
}
