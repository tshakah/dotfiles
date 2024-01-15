#!/usr/bin/env bash

if [[ $(git config --bool hooks.gitleaks) =~ "true" ]]; then
  if ! gitleaks protect -c ~/source/prima/appsec-automation/sast/sast-image/gitleaks/custom-config.toml -v --staged --redact; then
    echo -e "\n\e[31m\e[1mWarning:\e[0m\e[1m gitleaks has detected sensitive information in your changes."
    echo -e "To disable the gitleaks precommit hook run the following command:\n"
    echo -e "\e[33mgit config hooks.gitleaks false\e[0m\n"

    exit 1
  fi
  echo -e ""
else
  echo -e "\n\e[33m\e[1mgitleaks precommit hook disabled!\e[0m\e[1m"
  echo -e "You can enable with \e[32mgit config hooks.gitleaks true\e[0m\n"
fi
