gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye
set -e SSH_AUTH_SOCK
set -U -x SSH_AUTH_SOCK (gpgconf --list-dir agent-ssh-socket)
