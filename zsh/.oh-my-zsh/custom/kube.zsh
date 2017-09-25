function kubens {
  if [[ -z "$1" ]]; then
    echo "Usage: kubens <namespace>"
  else
    CONTEXT="$(kubectl config current-context)"
    kubectl config set-context "$CONTEXT" --namespace="$1"
  fi
}
