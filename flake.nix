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
        overrides = hnew: hold: {
          yesod-keter-nix = hnew.callCabal2nix "yesod-keter-nix" backend/. { };
          http-api-data = pkgs.haskell.lib.doJailbreak (hnew.callHackageDirect {
                pkg = "http-api-data";
                ver = "0.5";
                sha256 = "sha256-f0Igdb4EjJEEuuRE6rZ1iN44B1pCOp8dL/hoIulPcMU=";
          } {});
          postgresql-simple = hnew.callHackageDirect {
                pkg = "postgresql-simple";
                ver = "0.6.5";
                sha256 = "sha256-SRMDtXEBp+4B4/kESdsVT0Ul6AWd1REsSrvIP0WCEOw=";
                } {};
          persistent = hnew.callHackageDirect {
                pkg = "persistent";
                ver = "2.14.4.4";
                sha256 = "sha256-ytxLFmkJD/ch/vkRRlGoOA+UxdRBO7Pv2PgbhF5sDwk=";
                } {};
          persistent-test = hnew.callHackageDirect {
                pkg = "persistent-test";
                ver = "2.13.1.3";
                sha256 = "sha256-gb0YcyTM6SMdVhnMTwQD1aXQp/GJ8LjaFwzbHX5k49s=";
                } {};
          hjsmin = pkgs.haskell.lib.dontCheck (hnew.callHackageDirect {
                pkg = "hjsmin";
                ver = "0.2.1";
                sha256 = "sha256-XqjXEvFYuK0Emd3Zweug3Gy1/u7W8mD4kjpVtZR3F4g=";
          } {});
          chell = pkgs.haskell.lib.doJailbreak hold.chell;
          persistent-qq = pkgs.haskell.lib.dontCheck hold.persistent-qq;
        };
      };
    in
    {
      defaultPackage.x86_64-linux =  hpkgs.yesod-keter-nix;
      packages.x86_64-linux.example = pkgs.nixosTest {
          name = "keter-nix-example";
          nodes.server = import ./nix/server.nix { yesod-app = hpkgs.yesod-keter-nix; } ;
          testScript = ''
            server.start()
            server.wait_for_unit("postgresql.service")
            server.wait_for_console_text("error, called at")
            server.succeed("curl --fail http://localhost:8000/")
          '';
      #       server.wait_for_open_port(8000)
      #       server.wait_for_console_text("Activating app test-bundle with hosts: localhost")
      };
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
