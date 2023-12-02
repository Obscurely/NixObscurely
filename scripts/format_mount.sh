echo "--------------------------------------------------"
echo "-             Formatting disks...                -"
echo "--------------------------------------------------"

# zap all drives
echo "First completly wipe all disks"

sgdisk -Z /dev/nvme0n1
sgdisk -Z /dev/sda
sgdisk -Z /dev/sdb

# Create new partition tables (GPT) of 2048 alignment
echo "Creating new partition tables of type GPT of 2048 alignment."

sgdisk -a 2048 -o /dev/nvme0n1
sgdisk -a 2048 -o /dev/sda
sgdisk -a 2048 -o /dev/sdb

# Create partitons
echo "Making partitions."

# on /dev/nvme0n1 (nvme ssd)
sgdisk -n 1:0:+1024M /dev/nvme0n1  # partition 1 (EFI), 1GB
sgdisk -n 2:0:+16384M /dev/nvme0n1 # partition 2 (SWAP), 16GB
sgdisk -n 3:0:+102400M /dev/nvme0n1 # partition 3 (ROOT), 50GB
sgdisk -n 4:0:+204800M /dev/nvme0n1 # partition 4 (HOME), 200GB
#sudo sgdisk -n 5:0:0 /dev/nvme0n1       # partition 5, the rest in case I want to install another OS, 100GB, not actually creating the partition
# on /dev/sda (sata ssd)
sgdisk -n 1:0:+600000M /dev/sda # partition 1 (DATA), about 600GB, rest for windows dual boot
# on /dev/sdb (sshd)
sgdisk -n 1:0:+1331200M /dev/sdb # partition 1 (EXTRA), 1.3Tib
#sudo sgdisk -n 2:0:0 /dev/sdb # partition 2, the rest in case I want to install another OS, 500GB, not actaully creating the partition

# Set partition types
echo "Setting partition types."

# on /dev/nvme0n1 (nvme ssd)
sgdisk -t 1:ef00 /dev/nvme0n1 # making partition 1 type efi
sgdisk -t 2:8200 /dev/nvme0n1 # making partition 2 type linux swap
sgdisk -t 3:8300 /dev/nvme0n1 # making partition 3 type linux file system
sgdisk -t 4:8300 /dev/nvme0n1 # making partition 4 type linux file system
# on /dev/sda (sata ssd)
sgdisk -t 1:8300 /dev/sda # making partition 1 type linux file system
# on /dev/sdb (sshd)
sgdisk -t 1:8300 /dev/sdb # making partition 1 type linux file system

# Label partitions
echo "Labeling partitions."

# on /dev/nvme0n1 (nvme ssd)
sgdisk -c 1:"UEFISYS" /dev/nvme0n1
sgdisk -c 2:"SWAP" /dev/nvme0n1
sgdisk -c 3:"ROOT" /dev/nvme0n1
sgdisk -c 4:"HOME" /dev/nvme0n1
# on /dev/sda (sata ssd)
sgdisk -c 1:"DATA" /dev/sda
# on /dev/sdb (sshd)
sgdisk -c 1:"EXTRA" /dev/sdb

# Make filesystems
echo "Making file systems."

# on /dev/nvme0n1 (nvme ssd)
mkfs.vfat -F32 -n "UEFISYS" "/dev/nvme0n1p1" # formating efi partition with fat.
mkswap -L "SWAP" "/dev/nvme0n1p2"            # formating swap partition with linux swap.
mkfs.f2fs -f -l "ROOT" "/dev/nvme0n1p3"      # formating root partition with f2fs.
mkfs.f2fs -f -l "HOME" "/dev/nvme0n1p4"      # formating home partition with f2fs.
# on /dev/sda (sata ssd)
mkfs.f2fs -f -l "DATA" "/dev/sda1" # formating data partition with f2fs.
# on /dev/sdb (sshd)
mkfs.xfs -f -L "EXTRA" "/dev/sdb1"

# Mount targets
# mount root
mount "/dev/nvme0n1p3" /mnt # mounts root
# Create dirs for targets
mkdir /mnt/boot  # makes boot dir
mkdir /mnt/home  # makes home dir
mkdir /mnt/data  # makes data dir
mkdir /mnt/extra # make extra dir
# mount other targets
mount "/dev/nvme0n1p1" /mnt/boot # mounts boot
mount "/dev/nvme0n1p4" /mnt/home # mounts home
mount "/dev/sda1" /mnt/data      # mounts data
mount "/dev/sdb1" /mnt/extra     # mounts extra
swapon "/dev/nvme0n1p2"          # turns swap on
sleep 3                               # make sure everything is mounted, without can be buggy some times

echo "-------------------------------------------------"
echo "-   Done, please run run_in_nix_shell.sh now!   -"
echo "-------------------------------------------------"

# Enter a nix shell with git and nixVersions.stable (nixFlakes, got renamed for some reason)
nix-shell -p git nixVersions.stable
