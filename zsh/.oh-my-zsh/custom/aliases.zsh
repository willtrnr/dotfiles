# sudo shorthands
alias s=sudo
alias sv='sudo vim'

# Handy aliases to start sbt with a specific JDK version
alias sbt8='sbt -java-home /usr/lib/jvm/java-8-openjdk'
alias sbt11='sbt -java-home /usr/lib/jvm/java-11-openjdk'
alias sbt17='sbt -java-home /usr/lib/jvm/java-17-openjdk'
alias sbt21='sbt -java-home /usr/lib/jvm/java-21-openjdk'
alias sbt26='sbt -java-home /usr/lib/jvm/java-26-openjdk'

# Vim shorthands
alias v=vim
alias nv=nvim

# Cargo shorthand
alias c=cargo
alias cn='cargo +nightly'

# Bazel shorthand
alias b=bazel

# Secret generation, OWASP character set with some remove for compatibility
alias secgen="tr -dc 'A-Za-z0-9!%&()*+,-./<=>?[]^_|~' < /dev/urandom | head -c"
alias passgen="tr -dc 'A-Za-z0-9-_.' < /dev/urandom | head -c"

# Additional git aliases missing in git plugin
alias glr='git pull --rebase'
alias gmnff='git merge --no-ff'

# Additional kubectl aliases missing in kubectl
alias kdff='kubectl diff -f'
alias kdfk='kubectl diff -k'

# Python pip equivalent aliases for uv
alias upip='noglob uv pip'
alias upipgi='upip freeze | grep'
alias upipi='upip install'
alias upipir='upip install -r requirements.txt'
alias upiplo='upip list -o'
alias upipreq='upip freeze > requirements.txt'
alias upipun='upip uninstall'
