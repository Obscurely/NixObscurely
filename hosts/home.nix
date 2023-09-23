{
  lib,
  ...
}:
with builtins;
with lib; {
  ## Location config -- since Toronto is my 127.0.0.1
  time.timeZone = mkDefault "Europe/Bucharest";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "en_US.UTF-8";
  };
  # fake location for the sake of it
  location = {
    latitude = 43.70011;
    longitude = -79.4163;
  };
}
