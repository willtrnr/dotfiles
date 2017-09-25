function jjitlog {
  if [ "$1" = "on" ]; then
    if [[ "$JAVA_OPTS" != *"-XX:+PrintCompilation"* && "$JAVA_OPTS" != *"-XX:+UnlockDiagnosticVMOptions"* && "$JAVA_OPTS" != *"-XX:+PrintInlining"* ]]; then
      export JAVA_OPTS="$JAVA_OPTS -XX:+PrintCompilation -XX:+UnlockDiagnosticVMOptions -XX:+PrintInlining"
    fi
  else
    export JAVA_OPTS="$(echo "$JAVA_OPTS" | sed -e 's/-XX:+\(PrintCompilation\|UnlockDiagnosticVMOptions\|PrintInlining\)//g' -e 's/  */ /g')"
  fi
}

function jassert {
  if [ "$1" = "on" ]; then
    if [[ "$JAVA_OPTS" != *"-ea"* ]]; then
      export JAVA_OPTS="$JAVA_OPTS -ea"
    fi
  else
    export JAVA_OPTS="$(echo "$JAVA_OPTS" | sed -e 's/-ea//g' -e 's/  */ /g')"
  fi
}

function jgclog {
  if [ "$1" = "on" ]; then
    if [[ "$JAVA_OPTS" != *"-Xloggc:"* && "$JAVA_OPTS" != *"-XX:+PrintGCDetails"* && "$JAVA_OPTS" != *"-XX:+PrintTenuringDistribution"* && "$JAVA_OPTS" != *"-XX:+PrintGCCause"* && "$JAVA_OPTS" != *"-XX:+PrintAdaptiveSizePolicy"* ]]; then
      export JAVA_OPTS="$JAVA_OPTS -Xloggc:gc.log -XX:+PrintGCDetails -XX:+PrintTenuringDistribution -XX:+PrintGCCause -XX:+PrintAdaptiveSizePolicy"
    fi
  else
    export JAVA_OPTS="$(echo "$JAVA_OPTS" | sed -e 's/-Xloggc:gc.log\|-XX:+\(PrintGCDetails\|PrintTenuringDistribution\|PrintGCCause\|PrintAdaptiveSizePolicy\)//g' -e 's/  */ /g')"
  fi
}

function jg1gc {
  if [ "$1" = "on" ]; then
    if [[ "$JAVA_OPTS" != *"-XX:+UseG1GC"* ]]; then
      export JAVA_OPTS="$JAVA_OPTS -XX:+UseG1GC"
    fi
  else
    export JAVA_OPTS="$(echo "$JAVA_OPTS" | sed -e 's/-XX:+UseG1GC//' -e 's/  */ /g')"
  fi
}
