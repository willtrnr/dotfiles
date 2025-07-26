# FHS local only mount-points
IgnorePath '/media'
IgnorePath '/mnt'

# General local state
IgnorePath '/opt'
IgnorePath '/tmp'
IgnorePath '/var'

# Local accounts and related
for f in \
  group \
  gshadow \
  passwd \
  shadow \
  shells \
  subgid \
  subuid \
; do
  IgnorePath "/etc/$f"
  IgnorePath "/etc/$f-"
done

# Machine identity stuff
IgnorePath '/etc/hostname'
IgnorePath '/etc/hosts'
IgnorePath '/etc/machine-id'
IgnorePath '/etc/os-release'

# Pacman stuff
IgnorePath '*.pacnew'
IgnorePath '*.pacsave'
IgnorePath '/etc/pacman.d/*-backup'
IgnorePath '/etc/pacman.d/cachyos-*mirrorlist'
IgnorePath '/etc/pacman.d/gnupg'
IgnorePath '/etc/pacman.d/mirrorlist'

# Kernel modules
IgnorePath '/usr/lib/modules'

# Generated/false-positive files
IgnorePath '/etc/ca-certificates/extracted'
IgnorePath '/etc/ld.so.cache'
IgnorePath '/etc/ssl/certs'
IgnorePath '/etc/udev/hwdb.bin'
IgnorePath '/etc/vconsole.conf'
IgnorePath '/usr/bin/groupmems'
IgnorePath '/usr/bin/nopt'
IgnorePath '/usr/lib/gconv/gconv-modules.cache'
IgnorePath '/usr/lib/locale/locale-archive'
IgnorePath '/usr/lib/udev/hwdb.bin'
IgnorePath '/usr/lib/utempter/utempter'

# Local mount units
IgnorePath '/etc/systemd/system/*.mount'
IgnorePath '/etc/systemd/system/*.target/*.mount'

# Random temp files
IgnorePath '/etc/*.OLD'
IgnorePath '/etc/.pwd.lock'
IgnorePath '/etc/.updated'

# btrfs snapshots
IgnorePath '/.snapshots'

# Python stuff
IgnorePath '*/__pycache__/*'
IgnorePath '/usr/lib/python*/site-packages'

# ext4 garbage
IgnorePath '/lost+found'

# WSL injected files
IgnorePath '/etc/ld.so.conf.d/ld.wsl.conf'
IgnorePath '/etc/wsl-distribution.conf'
IgnorePath '/init'
IgnorePath '/usr/bin/mount.drvfs'
IgnorePath '/usr/bin/wslinfo'
IgnorePath '/usr/bin/wslpath'
IgnorePath '/usr/lib/wsl/*'
