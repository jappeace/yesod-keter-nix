{ config, pkgs, ... }: {
    services.keter = {
      enable = true;

      globalKeterConfig = {
        listeners = [{
          host = "*4";
          inherit port;
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
