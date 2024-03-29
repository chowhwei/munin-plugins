#!/usr/bin/env sh

get_memory_usage()
{
  keyword=$1
  ps aux | grep -i "$keyword" | grep -v grep | awk '{sum+=$6} END {print(sum * 1024)}'
  return
}

get_memory_usage2()
{
  keyword=$1
  os=$2
  sum=0
  case $os in
  "Linux")
    pids=$(pgrep -f -i "$keyword")
  ;;
  "Darwin")
    pids=$(pgrep -i "$keyword")
  ;;
  *)
    echo '0'
  esac
  for pid in $pids
  do
    sum=$((sum+$(ps -o rss= -p "$pid")*1024))
  done
  echo $sum;
  return
}

get_total_memory()
{
  os="$(get_os)"
  case $os in
  "Linux")
    free | awk '/Mem/ {print $2 * 1024}'
  ;;
  "Darwin")
    sysctl -n hw.memsize
  ;;
  *)
    echo '0'
  esac
}

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

os="$(get_os)"
echo "mem.value $(get_memory_usage "WeChat")"
echo "mem.value $(get_memory_usage2 "WeChat" "$os")"
echo "total.value $(get_total_memory)"