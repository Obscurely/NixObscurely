{
  config,
  options,
  lib,
  home-manager,
  ...
}:
with lib;
with lib.my; {
  options = with types; {
    user = mkOpt attrs {};

    dotfiles = {
      dir =
        mkOpt path
        (removePrefix "/mnt"
          (findFirst pathExists (toString ../.) [
            "/mnt/etc/dotfiles"
            "/etc/dotfiles"
          ]));
      binDir = mkOpt path "${config.dotfiles.dir}/bin";
      configDir = mkOpt path "${config.dotfiles.dir}/config";
      modulesDir = mkOpt path "${config.dotfiles.dir}/modules";
      themesDir = mkOpt path "${config.dotfiles.modulesDir}/themes";
    };

    home = {
      file = mkOpt' attrs {} "Files to place directly in $HOME";
      configFile = mkOpt' attrs {} "Files to place in $XDG_CONFIG_HOME";
      dataFile = mkOpt' attrs {} "Files to place in $XDG_DATA_HOME";
    };

    env = mkOption {
      type = attrsOf (oneOf [str path (listOf (either str path))]);
      apply =
        mapAttrs
        (n: v:
          if isList v
          then concatMapStringsSep ":" (x: toString x) v
          else (toString v));
      default = {};
      description = "TODO";
    };
  };

  config = {
    user = let
      user = builtins.getEnv "USER";
      name =
        if elem user ["" "root"]
        then "netrunner"
        else user;
    in {
      inherit name;
      description = "The primary user account";
      extraGroups = ["wheel" "libvirtd" "adbusers" "docker"];
      isNormalUser = true;
      hashedPassword = "$6$1NsZKTu22hR3MUfN$bZ6cnMbwDIB6pe2B.L8Kh5E9hAFjXkOWE0GUQ0SULiozrAepK3U9Ae5V9RPphitHGZ5emFtYwSsTbZbre/syc0";
      home = "/home/${name}";
      group = "users";
      uid = 1000;
    };

    # Install user packages to /etc/profiles instead. Necessary for
    # nixos-rebuild build-vm to work.
    home-manager = {
      useUserPackages = true;

      # I only need a subset of home-manager's capabilities. That is, access to
      # its home.file, home.xdg.configFile and home.xdg.dataFile so I can deploy
      # files easily to my $HOME, but 'home-manager.users.hlissner.home.file.*'
      # is much too long and harder to maintain, so I've made aliases in:
      users.${config.user.name} = {
        home = {
          file = mkAliasDefinitions options.home.file;
          # Necessary for home-manager to work with flakes, otherwise it will
          # look for a nixpkgs channel.
          stateVersion = config.system.stateVersion;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    # Make user accounts immutable
    users.mutableUsers = false;

    users.users.${config.user.name} = mkAliasDefinitions options.user;

    nix.settings = let
      users = ["root" config.user.name];
    in {
      trusted-users = users;
      allowed-users = users;
    };

    # must already begin with pre-existing PATH. Also, can't use binDir here,
    # because it contains a nix store path.
    env.PATH = ["$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH"];

    environment.extraInit =
      concatStringsSep "\n"
      (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
  };
}
