{yesod-app}: { config, pkgs, ... }: {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_12;
      initialScript = pkgs.writeText "psql-init" ''
        CREATE USER PROJECTNAME_LOWER WITH SUPERUSER PASSWORD 'PROJECTNAME';
        CREATE DATABASE PROJECTNAME_LOWER WITH OWNER PROJECTNAME_LOWER;
      '';
    };
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
          ${yesod-app}/bin/PROJECTNAME $PORT
        '';
      };
    };
  }
