# Handy aliases to start sbt with a specific JDK version
alias sbt8='sbt -java-home /usr/lib/jvm/java-8-openjdk'
alias sbt11='sbt -java-home /usr/lib/jvm/java-11-openjdk'
alias sbt17='sbt -java-home /usr/lib/jvm/java-17-openjdk'

# Vim shorthands
alias nv=nvim
alias v=nvim

# Poetry shorthand
alias p=poetry

# Cargo shorthand
alias c=cargo
alias cn='cargo +nightly'

# Secret generation, OWASP character set with problematic elemments removed
alias secgen="tr -dc 'A-Za-z0-9!%&()*+,-./<=>?[]^_|~' < /dev/urandom | head -c"
alias passgen="tr -dc 'A-Za-z0-9-_' < /dev/urandom | head -c"
