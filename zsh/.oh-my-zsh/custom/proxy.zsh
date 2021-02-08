function proxy_on {
  local proxy_user proxy_pass allow_prompt

  allow_prompt="${1:-1}"

  if [ -n "$http_proxy" ]; then
    return
  fi

  if [ -n "$http_proxy_user" ] && [ -n "$http_proxy_pass" ]; then
    # Use the env values as overrides and for scripting
    proxy_user="$http_proxy_user"
    proxy_pass="$http_proxy_pass"
  elif [ -f "$HOME/.credentials" ]; then
    # If we didn't have the env, use the general home credentials
    # The file can be empty, in which case we will assume password-less
    proxy_user="$(. $HOME/.credentials; echo "$username")"
    proxy_pass="$(. $HOME/.credentials; echo "$password")"
  elif [ "$allow_prompt" = "1" ]; then
    # As last resort, prompt the user
    # Ask the user for the credentials (or lack thereof)
    echo -n "Proxy username: "
    read proxy_user
    if [ -n "$proxy_user" ]; then
      echo -n "Proxy password: "
      read -s proxy_pass
    fi
  fi

  if [ -n "$proxy_user" ]; then
    # If we have a username, bake it in with the password
    export http_proxy="http://$proxy_user:$proxy_pass@$http_proxy_host:${http_proxy_port:-80}"
  else
    # Otherwise if we made it here we confirmed the use of password-less
    export http_proxy="http://$http_proxy_host:${http_proxy_port:-80}"
  fi
  export https_proxy="$http_proxy"
  export ftp_proxy="$http_proxy"

  # We'll at least try to setup the Java properties if we didn't already have something
  if [[ "$JAVA_OPTS" != *"http.proxy"* ]]; then
    export JAVA_OPTS="$JAVA_OPTS -Dhttp.proxyHost=$http_proxy_host -Dhttp.proxyPort=$http_proxy_port -Dhttp.nonProxyHosts='$(echo $no_proxy | sed 's/,/|/g')'"
    if [ -n "$proxy_user" ]; then
      export JAVA_OPTS="$JAVA_OPTS -Dhttp.proxyUser=$proxy_user -Dhttp.proxyPassword=$proxy_pass"
    fi
  fi
  if [[ "$JAVA_OPTS" != *"https.proxy"* ]]; then
    export JAVA_OPTS="$JAVA_OPTS -Dhttps.proxyHost=$http_proxy_host -Dhttps.proxyPort=$http_proxy_port -Dhttps.nonProxyHosts='$(echo $no_proxy | sed 's/,/|/g')'"
    if [ -n "$proxy_user" ]; then
      export JAVA_OPTS="$JAVA_OPTS -Dhttps.proxyUser=$proxy_user -Dhttps.proxyPassword=$proxy_pass"
    fi
  fi
}

function proxy_off {
  unset http_proxy
  unset https_proxy
  unset ftp_proxy

  export JAVA_OPTS="$(echo "$JAVA_OPTS" | sed 's/-Dhttp[[:graph:]]*[Pp]roxy[[:graph:]]*//g' | sed 's/  */ /g')"
}

proxy_on 0
