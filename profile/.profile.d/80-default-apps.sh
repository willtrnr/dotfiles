#!/usr/bin/env sh

# Select the best available editor
if (command -v nvim > /dev/null); then
  export EDITOR="$(command -v nvim)"
elif (command -v vim > /dev/null); then
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
if (command -v st > /dev/null); then
  export TERMINAL="$(command -v st)"
elif (command -v kitty > /dev/null); then
  export TERMINAL="$(command -v kitty)"
elif (command -v alacritty > /dev/null); then
  export TERMINAL="$(command -v alacritty)"
elif (command -v urxvt > /dev/null); then
  export TERMINAL="$(command -v urxvt)"
fi

# Select the best available browser
if (command -v google-chrome-beta > /dev/null); then
  export BROWSER="$(command -v google-chrome-beta)"
elif (command -v google-chrome-stable > /dev/null); then
  export BROWSER="$(command -v google-chrome-stable)"
elif (command -v chromium-snapshot-bin > /dev/null); then
  export BROWSER="$(command -v chromium-snapshot-bin)"
elif (command -v chromium > /dev/null); then
  export BROWSER="$(command -v chromium)"
elif (command -v firefox > /dev/null); then
  export BROWSER="$(command -v firefox)"
fi
