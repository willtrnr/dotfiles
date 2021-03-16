#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
  xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
  xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# start the hypervisor integrations if we have and need them
virt="$(systemd-detect-virt || true)"
if [ "$virt" == "oracle" ]; then
  # running in some VirtualBox variant
  if (command -v VBoxClient > /dev/null); then
    VBoxClient --clipboard
    VBoxClient --checkhostversion
  fi
elif [ "$virt" == "vmware" ]; then
  # running in some VMware product
  if (command -v vmware-user-suid-wrapper > /dev/null); then
    vmware-user-suid-wrapper
  elif (command -v vmware-user > /dev/null); then
    vmware-user
  fi
fi
unset virt

# setup compose key on right-alt and remape escape to caps lock
setxkbmap -option compose:ralt -option caps:escape

# fix compose in ui toolkits
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim

# start i3
if (command -v xcompmgr > /dev/null); then
  xcompmgr &
fi
exec i3
