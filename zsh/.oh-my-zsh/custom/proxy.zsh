function proxyon {
  if [ -z "$http_proxy" ]; then
    export http_proxy="http://$http_proxy_user:$http_proxy_pass@$http_proxy_host:$http_proxy_port"
    export https_proxy="$http_proxy"
  fi

  if [[ "$JAVA_OPTS" != *"http.proxy"* ]]; then
    export JAVA_OPTS="$JAVA_OPTS -Dhttp.proxyHost=$http_proxy_host -Dhttp.proxyPort=$http_proxy_port -Dhttp.proxyUser=$http_proxy_user -Dhttp.proxyPassword=$http_proxy_pass -Dhttp.nonProxyHosts='$(echo $no_proxy | sed 's/,/|/g')'"
  fi
  if [[ "$JAVA_OPTS" != *"https.proxy"* ]]; then
    export JAVA_OPTS="$JAVA_OPTS -Dhttps.proxyHost=$http_proxy_host -Dhttps.proxyPort=$http_proxy_port -Dhttps.proxyUser=$http_proxy_user -Dhttps.proxyPassword=$http_proxy_pass -Dhttps.nonProxyHosts='$(echo $no_proxy | sed 's/,/|/g')'"
  fi

  if [[ "$SBT_OPTS" != *"sbt.override.build.repos"* ]]; then
    export SBT_OPTS="$SBT_OPTS -Dsbt.override.build.repos=true"
  fi
}

function proxyoff {
  unset http_proxy
  unset https_proxy

  export JAVA_OPTS="$(echo "$JAVA_OPTS" | sed -e 's/-Dhttp[[:graph:]]*[Pp]roxy[[:graph:]]*//g' -e 's/  */ /g')"
  export SBT_OPTS="$(echo "$SBT_OPTS" | sed -e 's/-Dsbt.override.build.repos=true//' -e 's/  */ /g')"
}

if [ -f "$HOME/.credentials" ]; then
  . $HOME/.credentials
  export http_proxy_user="$username"
  export http_proxy_pass="$password"
fi

if [ -n "$http_proxy_host" ]; then
  proxyon
fi
