# Try to load .profile like other shells
if [ -f "$HOME/.profile" ]; then
  emulate sh -c 'source "$HOME/.profile"'
fi
