# run a few post setup things that I can't do using nix configs
echo "-----------------------------------------------------------------------"
echo "-  Running a few post setup things that I can't do using nix configs  -"
echo "-----------------------------------------------------------------------"

# Create xdg-user-dirs
echo "Create xdg user dirs"
mkdir Desktop
mkdir Documents
mkdir Downloads
mkdir Music
mkdir Pictures
mkdir Videos

# Create screenshots dir for flameshot
echo "Create screenshots dir for flameshot"
mkdir -p ~/Pictures/screenshots

# Create Code dir for programming
mkdir ~/Code

# Add xorg resolution fix (for lightdm)
echo "Add xorg resolution fix (for lightdm)"

sudo cp /etc/dotfiles/config/xorg/52-resolution-fix.conf /etc/X11/xorg.conf.d/.

# Install neovim configs
echo "Install neovim configs"

mkdir ~/.config/nvim # create nvim dir .config in case the installer didn't
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
git clone https://github.com/Obscurely/neovim.git ~/.config/nvim/lua/custom
arduino-cli config init
