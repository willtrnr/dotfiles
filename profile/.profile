# Path adjustments

if [ -d "$HOME/.nodebrew/current/bin" ]; then
  export PATH="$PATH:$HOME/.nodebrew/current/bin"
fi

if (command -v ruby > /dev/null); then
  export PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"
fi

if (command -v yarn > /dev/null); then
  export PATH="$PATH:$(yarn global bin)"
fi

# Select the best available editor

if (command -v vim > /dev/null); then
  export EDITOR="$(command -v vim)"
elif (command -v vi > /dev/null); then
  export EDITOR="$(command -v vi)"
elif (command -v nano > /dev/null); then
  export EDITOR="$(command -v nano)"
fi

# Select the best available pager

if (command -v less > /dev/null); then
  export PAGER="$(command -v less)"
elif (command -v more > /dev/null); then
  export PAGER="$(command -v more)"
fi

# Select the best available terminal, overrides the i3-sensible-terminal selection order
if (command -v kitty > /dev/null); then
  export TERMINAL="$(command -v kitty)"
elif (command -v urxvt > /dev/null); then
  export TERMINAL="$(command -v urxvt)"
fi

# Select the best available browser

if (command -v google-chrome-beta > /dev/null); then
  export BROWSER="$(command -v google-chrome-beta)"
elif (command -v google-chrome-stable > /dev/null); then
  export BROWSER="$(command -v google-chrome-stable)"
elif (command -v chromium > /dev/null); then
  export BROWSER="$(command -v chromium)"
elif (command -v firefox > /dev/null); then
  export BROWSER="$(command -v firefox)"
fi
