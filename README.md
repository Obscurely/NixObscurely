<h1 align="center">NixOS home-manager + flakes config</h1>

<img src="/screenshots/main/nvim.png" width="100%" />

<p align="center">
<span><img src="/screenshots/main/desktop.png" height="178" /></span>
<span><img src="/screenshots/main/sidebyside.png" height="178" /></span>
</p>

(see screenshots dir for more)

---

|                |                                                                |
| -------------- | -------------------------------------------------------------- |
| **Shell:**     | zsh + zgenom                                                   |
| **DM:**        | lightdm + lightdm-mini-greeter                                 |
| **WM:**        | bspwm + polybar                                                |
| **Editor:**    | [neovim][neovim]                                               |
| **Terminal:**  | Alacritty                                                      |
| **Launcher:**  | rofi                                                           |
| **Browser:**   | Zen, Librewolf, Firefox, Qutebrowser and Chromium              |
| **GTK Theme:** | [Fluent Dark](https://github.com/vinceliuice/Fluent-gtk-theme) |

---

## Quick start

### Phase 0 (getting the iso)

- Acquire NixOS 21.11 or newer:

  ```sh
  # Download the latest nixos-unstable minimal ISO
  wget -O nixos.iso https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso
  ```

- Switch to the root user
  ```sh
  sudo su
  ```

- Clone this repository
  ```sh
  nix-shell -p git
  git clone https://github.com/Obscurely/NixObscurely
  exit
  cd NixObscurely
  ```

### Phase 1 (partitioning)

#### Automatic

- Run [format_mount.sh](scripts/format_mount.sh) script (example script for my main pc, change accordingly)
  ```sh
  ./scripts/format_mount.sh
  ```

#### Manually

- Format your partitions as desired, a few utils and command that might interest you:
  - `sgdisk -Z /dev/sdX` to zap a drive (deltes all partitions)
  - `sgdisk -a 2048 -o /dev/sdX` to make a new gpt partition table
  - `cfdisk /dev/sdX` to do your partitioning
  - `mkfs.FS -f /dev/sdXN` (FS is a placeholder for the actual file system)
  - Also just take a look at the [format_mount.sh](scripts/format_mount.sh) script
- After doing your partitions mount them to `/mnt`, example:
  ```sh
  # Mount root
  mount /dev/sdX /mnt
  # Make necessary dirs
  mkdir /mnt/boot  # makes boot dir
  mkdir /mnt/home  # makes home dir
  # Mount boot and home part
  mount /dev/sdY /mnt/boot
  mount /dev/sdZ /mnt/home
  # Turn on swap
  swapon /dev/nvme0n1pX
  ```
  Again, just take a look at the [format_mount.sh](scripts/format_mount.sh) script.

### Phase 2 (installing the system)

#### **Please Read** before going any further

- The users are immutable, meaning it is automatically created on install and set a fixed password. Currently the config has a set password (hashed) and an user called netrunner. In order to change this, follow the next steps:
  - With your favorite text editior open the file `modules/options.nix`
  - First replace _netrunner_ with your desired username
  - Second where you see hashedPassword and inside the quotes a hash, replace that hash with the one of your desired password. In order to get a hash run the following command in your terminal `mkpasswd -m sha-512`, and after inputing your password it will give you the hash.

#### Automatic

- Run [run_in_nix_shell.sh](scripts/run_in_nix_shell.sh) script (example script for my main pc, change accordingly)
  ```sh
  ./scripts/run_in_nix_shell.sh
  ```

#### Manually

```sh
# Set HOST to the desired hostname of this system
HOST=...
# Set USER to your desired username (defaults to netrunner)
USER=...

cd ..
cp -r NixObscurely/ /etc/dotfiles/

# cd into that the dotfiles dir
cd /etc/dotfiles/

# get flakes
nix-shell -p git nixVersions.latest

# Create a host config and add it to the repo
mkdir -p hosts/$HOST
nixos-generate-config --root /mnt --dir /etc/dotfiles/hosts/$HOST
rm -f hosts/$HOST/configuration.nix
cp templates/hosts/desktop/default.nix hosts/$HOST/default.nix
vim hosts/$HOST/default.nix  # configure this for your system; don't use it as it is, take a look at least!
git add hosts/$HOST

# Installing NixOS
USER=$USER nixos-install --root /mnt --no-root-passwd --impure --flake .#$HOST

# move dotfiles to the mounted host
cp -r /etc/dotfiles /mnt/etc/dotfiles

# Reboot system
reboot
```

### Phase 3 (final)

- System deployment complete. Proceed with standard operations.

## Other

### Browsers (such as Zen or Librewolf)

Due to NixOS sandboxing constraints and the necessity to maintain strict credential security, browsers need to be configured manually (with quick and easy instructions). Configuration documentation is available in [config/zen/settings.md](./config/zen/settings.md) or similarly for librewolf.

### Nvidia

Hardware-specific GPU optimizations are explicitly omitted from the automated declarative state to prevent conflicting power profiles across deployment targets. Manual application is required:

- OpenGL Settings: set Image Settings to High Performance
- PowerMizer: set Preffered Mode to Prefer Maximum Performance

## Management

CLI management tooling adapted from hlissner/dotfiles.

```
Usage: hey [global-options] [command] [sub-options]

Available Commands:
  check                  Run 'nix flake check' on your dotfiles
  gc                     Garbage collect & optimize nix store
  generations            Explore, manage, diff across generations
  help [SUBCOMMAND]      Show usage information for this script or a subcommand
  rebuild                Rebuild the current system's flake
  repl                   Open a nix-repl with nixpkgs and dotfiles preloaded
  rollback               Roll back to last generation
  search                 Search nixpkgs for a package
  show                   [ARGS...]
  ssh HOST [COMMAND]     Run a bin/hey command on a remote NixOS system
  swap PATH [PATH...]    Recursively swap nix-store symlinks with copies (and back).
  test                   Quickly rebuild, for quick iteration
  theme THEME_NAME       Quickly swap to another theme module
  update [INPUT...]      Update specific flakes or all of them
  upgrade                Update all flakes and rebuild system

Options:
    -d, --dryrun                     Don't change anything; perform dry run
    -D, --debug                      Show trace on nix errors
    -f, --flake URI                  Change target flake to URI
    -h, --help                       Display this help, or help for a specific command
    -i, -A, -q, -e, -p               Forward to nix-env
```

## Credits

- [NixOS Manual](https://nixos.org/manual/nixos/unstable) great resource to get started fast.
- [NixOS Options](https://search.nixos.org/options) being able to search for an option it's really useful and helped me a ton.
- Base architectural patterns adapted from hlissner/dotfiles. The current iteration is heavily customized (>90%) for this specific deployment architecture.

## Frequently asked questions

- **Why NixOS?**

  NixOS provides a declarative, immutable infrastructure. This ensures reproducible system state across multiple machines and enables exact environment replication. It eliminates configuration drift, simplifies disaster recovery, and provides atomic rollbacks in the event of a failed update. These characteristics are essential for maintaining consistent operational environments.

- **Should I use NixOS?**

  NixOS is recommended for environments requiring strict reproducibility and declarative configuration management. It is suitable for managing multiple systems with identical specifications. However, it carries a high initial setup overhead due to its unique architecture and functional configuration language. A solid understanding of Linux systems and the Nix language is required for effective management.

- **Flake Resources**

  - [Tweag introduction to Flakes](https://www.tweag.io/blog/2020-05-25-flakes/)
  - [DevOS advanced configuration architecture](https://github.com/divnix/devos)
  - [Minimalistic Flake boilerplate](https://github.com/colemickens/nixos-flake-example)
  - [NixOS Wiki: Flake format specification](https://nixos.wiki/wiki/Flakes)
  - [Official NixOS Documentation](https://nixos.org/learn.html)
  - [Video resources on NixOS tooling](https://www.youtube.com/channel/UC-cY3DcYladGdFQWIKL90SQ)
  - Reference Configurations: [LEXUGE](https://github.com/LEXUGE/nixos), [bqv](https://github.com/bqv/nixrc), [dunklecat](https://git.sr.ht/~dunklecat/nixos-config/tree), [utdemir](https://github.com/utdemir/dotfiles), [purcell](https://github.com/purcell/dotfiles).
  - [Justin Woo's Nix Shorts](https://github.com/justinwoo/nix-shorts)
  - [NixOS development environment generators](https://myme.no/posts/2020-01-26-nixos-for-development.html)

[neovim]: https://github.com/neovim/neovim
[nixos]: https://releases.nixos.org/?prefix=nixos/unstable/
