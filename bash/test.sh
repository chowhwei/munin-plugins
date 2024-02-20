#!/usr/bin/env sh

test()
{
  echo "$1"
  echo "$2"

  if [ "$1" = "1" ]; then
    return 100
  else
    return 200
  fi
}

test "$1" "$2"

a=$?

echo $a