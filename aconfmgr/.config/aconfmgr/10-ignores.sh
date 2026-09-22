# FHS local only mount-points
IgnorePath '/media'
IgnorePath '/mnt'

# General local state
IgnorePath '/opt'
IgnorePath '/run'
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

# Machine identity
IgnorePath '/etc/hostname'
IgnorePath '/etc/hosts'
IgnorePath '/etc/machine-id'
IgnorePath '/etc/os-release'

# Pacman
IgnorePath '*.pacnew'
IgnorePath '*.pacsave'
IgnorePath '/etc/pacman.d/*-backup'
IgnorePath '/etc/pacman.d/cachyos-*mirrorlist'
IgnorePath '/etc/pacman.d/gnupg'
IgnorePath '/etc/pacman.d/mirrorlist'

# Kernel modules
IgnorePath '/usr/lib/modules'

# Local enabled systemd units
IgnorePath '/etc/systemd/system/*.mount'
IgnorePath '/etc/systemd/system/*.target.wants'
IgnorePath '/etc/systemd/system/*.target/*.mount'
IgnorePath '/etc/systemd/system/ctrl-alt-del.target'
IgnorePath '/etc/systemd/system/dbus-org.*'
IgnorePath '/etc/systemd/system/systemd-firstboot.service'

# Generated/false-positive files
IgnorePath '/etc/ca-certificates/extracted'
IgnorePath '/etc/fonts/conf.d'
IgnorePath '/etc/ld.so.cache'
IgnorePath '/etc/ssl/certs'
IgnorePath '/etc/udev/hwdb.bin'
IgnorePath '/etc/vconsole.conf'
IgnorePath '/usr/bin/groupmems'
IgnorePath '/usr/bin/nopt'
IgnorePath '/usr/lib/gconv/gconv-modules.cache'
IgnorePath '/usr/lib/gdk-pixbuf-2.0/*/loaders.cache'
IgnorePath '/usr/lib/gio/modules/giomodule.cache'
IgnorePath '/usr/lib/gtk-2.0/*/immodules.cache'
IgnorePath '/usr/lib/gtk-3.0/*/immodules.cache'
IgnorePath '/usr/lib/gtk-4.0'
IgnorePath '/usr/lib/jvm/default'
IgnorePath '/usr/lib/jvm/default-runtime'
IgnorePath '/usr/lib/locale/locale-archive'
IgnorePath '/usr/lib/udev/hwdb.bin'
IgnorePath '/usr/lib/utempter/utempter'
IgnorePath '/usr/share/applications/mimeinfo.cache'
IgnorePath '/usr/share/glib-2.0/schemas/gschemas.compiled'
IgnorePath '/usr/share/icons/*/icon-theme.cache'
IgnorePath '/usr/share/info'
IgnorePath '/usr/share/man'
IgnorePath '/usr/share/mime'
IgnorePath '/usr/share/vim/vimfiles/doc'

# Random temp/backup files
IgnorePath '/etc/*.OLD'
IgnorePath '/etc/.pwd.lock'
IgnorePath '/etc/.updated'

# btrfs snapshots
IgnorePath '/.snapshots'

# Python
IgnorePath '*/__pycache__/*'
IgnorePath '/usr/lib/python*/site-packages'

# Node
IgnorePath '/usr/lib/node_modules'

# ext4 garbage
IgnorePath '/lost+found'

# WSL injected files
IgnorePath '/etc/ld.so.conf.d/ld.wsl.conf'
IgnorePath '/etc/systemd/resolved.conf.d/wsl.conf'
IgnorePath '/etc/wsl-distribution.conf'
IgnorePath '/etc/wsl.conf'
IgnorePath '/init'
IgnorePath '/usr/bin/mount.drvfs'
IgnorePath '/usr/bin/wslinfo'
IgnorePath '/usr/bin/wslpath'
IgnorePath '/usr/lib/wsl'
