<h1 align="center">NixOS home-manager + flakes config</h1>

<img src="/screenshots/main/nvim.png" width="100%" />

<p align="center">
<span><img src="/screenshots/main/desktop.png" height="178" /></span>
<span><img src="/screenshots/main/sidebyside.png" height="178" /></span>
</p>

(see screenshots dir for more)

------

|                |                                                          |
|----------------|----------------------------------------------------------|
| **Shell:**     | zsh + zgenom                                             |
| **DM:**        | lightdm + lightdm-mini-greeter                           |
| **WM:**        | bspwm + polybar                                          |
| **Editor:**    | [neovim][neovim]                                         |
| **Terminal:**  | kitty                                                    |
| **Launcher:**  | rofi                                                     |
| **Browser:**   | Qutebrowser, Firefox and Chromium                        |
| **GTK Theme:** | [Fluent Dark](https://github.com/vinceliuice/Fluent-gtk-theme) |

-----

## Quick start
### Phase 0 (getting the iso)
* Acquire NixOS 21.11 or newer:
   ```sh
   # Yoink nixos-unstable
   wget -O nixos.iso https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso
   
   # If you don't know how to boot an iso than NixOS is most likely not for you.
   ```
* Clone this repository
  ```sh
  nix-shell -p git
  git clone https://github.com/Obscurely/NixObscurely
  exit
  cd NixObscurely
  ```

### Phase 1 (partitioning)
#### Automatic
* Run [format_mount.sh](scripts/format_mount.sh) script (example script for my main pc, change accordingly)
  ```sh
  ./scripts/format_mount.sh
  ```
#### Manually
* Format your partitions as desired, a few utils and command that might interest you:
  * ```sgdisk -Z /dev/sdX``` to zap a drive (deltes all partitions)
  * ```sgdisk -a 2048 -o /dev/sdX``` to make a new gpt partition table
  * ```cfdisk /dev/sdX``` to do your partitioning
  * ```mkfs.FS -f /dev/sdXN``` (FS is a placeholder for the actual file system)
  * Also just take a look at the [format_mount.sh](scripts/format_mount.sh) script
* After doing your partitions mount them to ```/mnt```, example:
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
* The users are immutable, meaning it is automatically created on install and set a fixed password. Currently the config has a set password (hashed) and an user
called netrunner. In order to change this, follow the next steps:
  * With your favorite text editior open the file ```modules/options.nix```
  * First replace _netrunner_ with your desired username
  * Second where you see hashedPassword and inside the quotes a hash, replace that hash with the one of your desired password. In order to get a hash run the 
  following command in your terminal ```mkpasswd -m sha-512```, and after inputing your password it will give you the hash.

#### Automatic
* Run [run_in_nix_shell.sh](scripts/run_in_nix_shell.sh) script (example script for my main pc, change accordingly)
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
* Start being productive already god damn it! you already wasted hours reconfiguring your system!!!

## Management

Hey, a script i stole from here [hlissner/dotfiles](https://github.com/hlissner/dotfiles), more on stealing (inspiration) later.

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
* [NixOS Manual](https://nixos.org/manual/nixos/unstable) great resource to get started fast.
* [NixOS Options](https://search.nixos.org/options) being able to search for an option it's really useful and helped me a ton.
* [hlissner's dotfiles](https://github.com/hlissner/dotfiles) without this guy's dotfiles I wouldn't have ever switched to NixOS because
it has a very steep learning curve (understanding how to setup flakes and home manager with how little resources are available is a nightmare), 
luckily I found these, which after looking at a lot of other configs they were the perfect fit for me. I only used them as a very basic base, the structure
and for a script or two. Most of the config (90%+) is my work, but it wouldn't have been possible without his work.

## Frequently asked questions (mostly copied from hlissner's readme file)

+ **Why NixOS?**

  Well, for a few reasons. First I have a tendency of formatting and reinstalling my OSes on my main computer quite often which until now has been done
  by using a very handy set of scripts i wrote for Arch Linux ([ArchObscurely](https://github.com/Obscurely/ArchObscurely)). Problem is every so often
  there would be a problem, changes, or simply random (one time) errors that will take a lot of my time to debug and restart the install. By using NixOS
  this is solved since as long as the flakes aren't updated this will always install.</br>
  Second there is no way, no matter how configured your system is, that at one point you will not find a new useful program, make some changes to your
  system, and with NixOS this ain't a problem make the changes, rebuild the config, push the changes to your git cloud and done, they are saved. When
  I was using Arch I always had to remember to back up my dotfiles, to remember to make the adjusments to the scripts which was just a pain.</br>
  Third I don't only use a computer, I use a couple and being able to easily have the same config, same software across all of them, easily syncable is a
  must for me.</br>
  Fourth, because of the nature of NixOS and the way you configure it, it makes it more configurable than other distros (imo), while also sort of helping
  you configure it right.</br>
  Fifth, being able to go back to a previous configuration in case an update broke something and continue on with my critical (must do now) work, then 
  take the time to fix it is a life changer.

+ **Should I use NixOS?**

  **Short answer:** no.
  
  **Long answer:** no really. Don't.
  
  **Long long answer:** I'm not kidding. Don't.
  
  **Unsigned long long answer:** Alright alright. Here's why not:

  - Its learning curve is steep.
  - You _will_ trial and error your way to enlightenment, if you survive long
    enough.
  - NixOS is unlike other Linux distros. Your issues will be unique and
    difficult to google.
  - If the words "declarative", "generational", and "immutable" don't make you
    _fully_ erect, you're considering NixOS for the wrong reasons.
  - The overhead of managing a NixOS config will rarely pay for itself with
    fewer than 3 systems (perhaps another distro with nix on top would suit you
    better?).
  - Official documentation for Nix(OS) is vast, but shallow.
  - Unofficial resources and example configs are sparse and tend to be either
    too simple or too complex (or outdated).
  - The Nix language is obtuse and its toolchain is unintuitive. This is made
    infinitely worse if you've never touched the shell or a functional language
    before, but you'll _need_ to learn it to do even a fraction of what makes
    NixOS worth all the trouble.
  - A decent grasp of Linux and its ecosystem is a must, if only to distinguish
    Nix(OS) issues from Linux (or upstream) issues -- as well as to debug them
    or report them to the correct authority (and coherently).
  - If you need somebody else to tell you whether or not you need NixOS, you
    don't need NixOS.

  If none of this has deterred you, then you didn't need my advice in the first
  place. Stop procrastinating and try NixOS!
 
+ **How 2 flakes?**
    
    I only used the NixOS official documentation and hlissner's dotfiles as a base. I learned flakes by playing around with the config which for me
    wasn't a problem. But if you want to learn more about flakes I will leave here the resources hlissner left too in his readme.
  
  + [A three-part tweag article that everyone's read.](https://www.tweag.io/blog/2020-05-25-flakes/)
  + [An overengineered config to scare off beginners.](https://github.com/divnix/devos)
  + [A minimalistic config for scared beginners.](https://github.com/colemickens/nixos-flake-example)
  + [A nixos wiki page that spells out the format of flake.nix.](https://nixos.wiki/wiki/Flakes)
  + [Official documentation that nobody reads.](https://nixos.org/learn.html)
  + [Some great videos on general nixOS tooling and hackery.](https://www.youtube.com/channel/UC-cY3DcYladGdFQWIKL90SQ)
  + A couple flake configs that I 
    [may](https://github.com/LEXUGE/nixos) 
    [have](https://github.com/bqv/nixrc)
    [shamelessly](https://git.sr.ht/~dunklecat/nixos-config/tree)
    [rummaged](https://github.com/utdemir/dotfiles)
    [through](https://github.com/purcell/dotfiles).
  + [Some notes about using Nix](https://github.com/justinwoo/nix-shorts)
  + [What helped me figure out generators (for npm, yarn, python and haskell)](https://myme.no/posts/2020-01-26-nixos-for-development.html)
  + [Learn from someone else's descent into madness; this journals his
    experience digging into the NixOS
    ecosystem](https://www.ianthehenry.com/posts/how-to-learn-nix/introduction/)
  + [What y'all will need when Nix drives you to drink.](https://www.youtube.com/watch?v=Eni9PPPPBpg)

[neovim]: https://github.com/neovim/neovim
[nixos]: https://releases.nixos.org/?prefix=nixos/unstable/
