{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; {
  imports =
    # Config Files
    [inputs.home-manager.nixosModules.home-manager]
    # Modules installing apps and configs
    ++ (mapModulesRec' (toString ./modules) import);

  # Common config
  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix = let
    filteredInputs = filterAttrs (n: _: n != "self") inputs;
    nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
    registryInputs = mapAttrs (_: v: {flake = v;}) filteredInputs;
  in {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
    nixPath =
      nixPathInputs
      ++ [
        "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
        "dotfiles=${config.dotfiles.dir}"
      ];
    registry = registryInputs // {dotfiles.flake = inputs.self;};
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
    };
  };
  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "21.05";

  # Don't flag missing hardware config file
  fileSystems."/".device = mkDefault "/dev/disk/by-label/nixos";

  # Per interface is enforced
  networking.useDHCP = mkDefault false;

  # Enable wake on lan
  networking.interfaces.enp8s0.wakeOnLan.enable = true;

  # Fix bug when running both ipv6 and ipv4
  networking.resolvconf.dnsSingleRequest = true;

  # Use the latest kernel
  boot = {
    kernelPackages = mkDefault pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = mkDefault true;
    };
  };

  # Enable architecture emulation
  boot.binfmt.emulatedSystems = ["aarch64-linux" "x86_64-windows" "i686-linux"];

  # Just the bear necessities
  environment.systemPackages = with pkgs; [
    bind
    cached-nix-shell
    git
    vim
    wget
    gnumake
    unzip
  ];
}
