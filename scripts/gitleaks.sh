#!/usr/bin/env bash

if git config --bool hooks.gitleaks; then
  if ! gitleaks protect -c ~/source/prima/appsec-automation/sast/sast-image/gitleaks/custom-config.toml -v --staged --redact; then
    echo -e "Warning: gitleaks has detected sensitive information in your changes.\n"
            "To disable the gitleaks precommit hook run the following command:\n\n"
            "git config hooks.gitleaks false"
  fi
fi
