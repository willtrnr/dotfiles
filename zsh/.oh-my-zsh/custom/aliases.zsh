# Fix the bsp start command with coursier launcher
alias fixbsp='jq '"'"'.argv = ["/usr/bin/sbt","-bsp"]'"'"' .bsp/sbt.json | sponge .bsp/sbt.json'

# Handy aliases to start sbt with a specific JDK version
alias sbt8='sbt -java-home /usr/lib/jvm/java-8-openjdk'
alias sbt11='sbt -java-home /usr/lib/jvm/java-11-openjdk'

# Vim shorthands
alias nv=nvim
alias v=nvim

# Poetry shorthands
alias p=poetry
alias psh='poetry shell'
alias pr='poetry run'

# Cargo shorthands
alias c=cargo
alias cb='cargo build'
alias cr='cargo run'
alias ct='cargo test'
