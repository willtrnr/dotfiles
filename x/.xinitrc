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

# start the VBox integrations if we have them

if (command -v VBoxClient-all > /dev/null); then
  VBoxClient-all
elif (command -v VBoxClient > /dev/null); then
  VBoxClient --clipboard
  VBoxClient --checkhostversion
  VBoxClient --display
  VBoxClient --seamless
  VBoxClient --draganddrop
  VBoxClient --vmsvga-x11
fi

# start the VMware integrations if we have them

if (command -v vmware-user-suid-wrapper > /dev/null); then
  vmware-user-suid-wrapper
elif (command -v vmware-user > /dev/null); then
  vmware-user
fi

# setup compose keys

setxkbmap -option compose:ralt

export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim

# start i3

exec /usr/bin/i3
