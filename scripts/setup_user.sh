# running a few post setup things that can't really be done using nix
# this script is made to be ran anytime you want as it checks if the files are already present
# hence why it is run as an activation script

# cd into home dir just to make sure
cd ~

# Create xdg-user-dirs

if ! [ -d "Desktop" ]; then
  mkdir ~/Desktop
fi

if ! [ -d "Documents" ]; then
  mkdir ~/Documents
fi
if ! [ -d "Downloads" ]; then
  mkdir ~/Downloads
fi

if ! [ -d "Music" ]; then
  mkdir ~/Music
fi

if ! [ -d "Pictures" ]; then
  mkdir ~/Pictures
fi

if ! [ -d "Videos" ]; then
  mkdir ~/Videos
fi

# Create screenshots dir for flameshot

if ! [ -d "Pictures/screenshots" ]; then
  mkdir -p ~/Pictures/screenshots
fi

# Create Code dir for programming

if ! [ -d "Code" ]; then
  mkdir ~/Code
fi

# Install neovim configs

if ! [ -d "Code" ]; then
  mkdir ~/Code
fi

if ! [ -d ".config/nvim/.git" ]; then
  mkdir ~/.config/nvim # create nvim dir .config in case the installer didn't
  git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
  git clone https://github.com/Obscurely/neovim.git ~/.config/nvim/lua/custom
  arduino-cli config init
fi

# Load locckscreen image if there is one
if [ -f "$XDG_DATA_HOME/lockscreen.jpg" ]; then
  betterlockscreen -u "$XDG_DATA_HOME/lockscreen.jpg" &
fi

touch ~/scriprun
