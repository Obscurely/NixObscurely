{ config, lib, ... }:

with builtins;
with lib;
{
  ## Location config -- since Toronto is my 127.0.0.1
  time.timeZone = mkDefault "Europe/Bucharest";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  location = {
    latitude = 43.70011;
    longitude = -79.4163;
  };

  # So the vaultwarden CLI knows where to find my server.
  #modules.shell.vaultwarden.config.server = "vault.lissner.net";
}
