#!/usr/bin/env bash

run_mix_tests() {
  touch .watchexec_status
  read current_status < .watchexec_status

  mix test --stale

  result=$?

  if [[ $result == 0 ]]; then
    if [[ $current_status != 'GREAT' ]]; then
      notify-send -u normal "TESTS ARE NOW PASSING" "PARTY ^^" -t 5000
    else
      notify-send -u low "TESTS ARE STILL PASSING" "MOAR PARTY ~(^-^)~" -t 5000
    fi

    echo 'GREAT' > .watchexec_status
  else
    if [[ $current_status == 'BAD. VERY VERY BAD' ]]; then
      notify-send -u critical "TESTS ARE STILL FAILING" "(╯°□°）╯︵ ┻━┻" -t 5000
    else
      notify-send -u critical "YOU BROKE THE CODE" "MUCH SADNESS :(" -t 5000
    fi

    echo 'BAD. VERY VERY BAD' > .watchexec_status
  fi
}

export -f run_mix_tests

watchexec --exts ex,exs --restart --clear run_mix_tests
