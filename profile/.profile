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
  export EDITOR="$(command -v more)"
fi
