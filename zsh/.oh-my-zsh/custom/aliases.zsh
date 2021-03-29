# Fix the bsp start command with coursier launcher
alias fixbsp='jq '"'"'.argv = ["/usr/bin/sbt","-bsp"]'"'"' .bsp/sbt.json | sponge .bsp/sbt.json'

# Handy aliases to start sbt with a specific JDK version
alias sbt8='sbt -java-home /usr/lib/jvm/java-8-openjdk'
alias sbt11='sbt -java-home /usr/lib/jvm/java-11-openjdk'
