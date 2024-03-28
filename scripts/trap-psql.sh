#!/usr/bin/env bash

# From https://unix.stackexchange.com/questions/464106/killing-background-processes-started-in-nix-shell
# (with a few minor modifications)

set -eu

client_pid=$PPID

start_postgres() {
    if postgres_is_stopped
    then
        logfile="$PWD/db/log/pg.log"
        mkdir -p "$PGHOST" "${logfile%/*}"
        (set -m
        pg_ctl start --silent -w --log "$logfile" -o "-k $PGHOST -h ''")
    fi
}

postgres_is_stopped() {
    pg_ctl status >/dev/null
    (( $? == 3 ))
}

case "$1" in
    add)
        mkdir -p "$HOME/.local/share/db/client/pids"
        touch "$HOME/.local/share/db/client/pids/$client_pid"
        if [ -d "$PGDATA" ]
        then
            start_postgres
        else
            pg_ctl initdb --silent -o '--auth=trust' && start_postgres && createdb $PGDATABASE
        fi
        ;;
    remove)
        rm "$HOME/.local/share/db/client/pids/$client_pid"
        if [ -n "$(find "$HOME/.local/share/db/client/pids" -prune -empty)" ]
        then
            pg_ctl stop --silent -W
        fi
        ;;
    *)
        echo "Usage: ${BASH_SOURCE[0]##*/} {add | remove}"
        exit 1
        ;;
esac
