{yesod-app, keter}: { config, pkgs, ... }: {

    environment.extraInit = ''
    mkdir -p /static
    '';
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_12;
      initialScript = pkgs.writeText "psql-init" ''
        CREATE USER username WITH SUPERUSER PASSWORD 'hunter42';
        CREATE DATABASE db WITH OWNER username;
      '';
    };

    services.keter = {
      enable = true;
      keterPackage = keter;

      globalKeterConfig = {
        listeners = [{
          host = "*4";
          port = 8000;
        }];
        rotate-logs = false;
      };
      bundle = {
        appName = "test-bundle";
        domain = "localhost";
        publicScript = ''
          export YESOD_PORT=$PORT
          export YESOD_STATIC_DIR=/static
        '';
        # TODO don't put the pass in the nix store ;)
        secretScript = ''
          export YESOD_PGDATABASE=db;
          export YESOD_PGPASS=hunter42;
          export YESOD_PGUSER=username;
        '';
        executable = pkgs.writeShellScript "run" ''
          ${yesod-app}/bin/PROJECTNAME ${../backend/config/settings.yml}
        '';
      };
    };
  }
