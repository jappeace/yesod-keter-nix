{ config, pkgs, ... }: {
    services.keter = {
      enable = true;

      globalKeterConfig = {
        listeners = [{
          host = "*4";
          port = 8000;
        }];
      };
      bundle = {
        appName = "test-bundle";
        domain = "localhost";
        executable = pkgs.writeShellScript "run" ''
          ${pkgs.haskell.packages.ghc943.yesod-keter-nix}/bin/PROJECTNAME $PORT
        '';
      };
    };
  };
