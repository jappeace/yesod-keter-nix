# I used chatgpt to generate this template and then just
# modified to how I normally use these things.
{
  description = "My Haskell project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-compat }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      hpkgs = pkgs.haskell.packages.ghc943.override {
        overrides = hold: hnew: {
          yesod-keter-nix = hnew.callCabal2nix "yesod-keter-nix" ./. { };
        };
      };
    in
    {
      defaultPackage.x86_64-linux =  hpkgs.template-project;
      devShell.x86_64-linux = hpkgs.shellFor {
        packages = ps : [ ps."yesod-keter-nix" ];
        withHoogle = true;

        buildInputs = [
          pkgs.ghcid
          pkgs.cabal-install
        ];
      };
    };
}
