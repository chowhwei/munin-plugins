#!/usr/bin/env sh

get_os()
{
  os=$(uname -s | awk -F '_' '{print $1}')
  if [ "$os" = 'Darwin' ]; then
    echo 'Darwin'
  elif [ "$os" = 'Linux' ]; then
    echo 'Linux'
  elif [ "$os" = 'MINGW64_NT' ]; then
    echo 'WINNT'
  else
    echo 'Unknown'
  fi
}

get_os