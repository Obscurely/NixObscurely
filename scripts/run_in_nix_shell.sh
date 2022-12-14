# Create dir for dotfiles (in live iso)
echo "---------------------------------------"
echo "-  Running commands inside nix-shell  -"
echo "---------------------------------------"

# make dir for dotfiles
echo "Move dotfiles to new root."

cd ..
cp -r NixObscurely/ /etc/dotfiles/

# cd into that dir
cd /etc/dotfiles/

# remove old main host and remake it
echo "Removing old main host and remaking it."

# remove old host
rm -rf hosts/main
mkdir -p hosts/main

# remake old host
nixos-generate-config --root /mnt --dir /etc/dotfiles/hosts/main
rm -f hosts/main/configuration.nix
cp templates/hosts/desktop/default.nix hosts/main/default.nix
git add hosts/main

# Installing NixOS
echo "----------------------"
echo "-  Installing NixOS  -"
echo "----------------------"

USER=netrunner nixos-install --root /mnt --no-root-passwd --impure --flake .#main

# move dotfiles to mounted host
echo "Move dotfiles to the mounted host"

cp -r /etc/dotfiles /mnt/etc/dotfiles

echo "------------------------------"
echo "-  Done, you can now reboot!  "
echo "------------------------------"
