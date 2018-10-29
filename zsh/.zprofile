# Try to load .profile like the other shells
if [ -f ~/.profile ]; then
  emulate sh -c 'source ~/.profile'
fi
