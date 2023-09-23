{
  minimal = {
    path = ./minimal;
    description = "A grossly incandescent and minimal nixos config";
  };

  # Hosts
  host-desktop = {
    path = ./hosts/desktop;
    description = "A starter hosts/* config for someone's daily driver";
  };
  # host-linode = {
  #   path = ./hosts/linode;
  #   description = "A starter hosts/* config for a Linode config";
  # };
  # host-server = {
  #   path = ./hosts/homeserver;
  #   description = "A starter hosts/* config for a home server config";
  # };
}
