# sudo shorthands
alias s=sudo
alias sv='sudo vim'

# Handy aliases to start sbt with a specific JDK version
alias sbt8='sbt -java-home /usr/lib/jvm/java-8-openjdk'
alias sbt11='sbt -java-home /usr/lib/jvm/java-11-temurin'
alias sbt17='sbt -java-home /usr/lib/jvm/java-17-temurin'

# Vim shorthands
alias v=nvim
alias nv=nvim

# Poetry shorthand
alias p=poetry
alias pp='poetry run poe'

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
