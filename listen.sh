#!/bin/bash
#
# Currently needs mpv, youtube-dl and ag
#
# Issues:
# Only listening to youtube
# Not allowing to only search on tops
#
# Todo:
# Allow soundcloud clips
# Redirect the mpv output and allow for keyboard shortcuts to cycle through
# Allow pagination

URL_REGEX="http(s)?://(www\.)?youtu(\.)?be"
USER_TAG=""


valid_url() {
   [[ $1 =~ $URL_REGEX ]]
}

current_tag() {
  [[ $1 == $USER_TAG || $USER_TAG == "" ]]
}

music_info() {
  echo $@ | sed -e 's/( )*\(.*\)( )*--( )*\(.*\)( )*\([0-9]+\).*/\1 -- \2 (\3)/'
}

play_song() {
  echo "Now playing: ${*:2}"
  mpv --no-video $1
}

lower() {
  echo $@ | awk '{print tolower($0)}'
}

read_song() {
  while read -r line; do
    url=$(echo $line | pup 'a.title attr{href}')
    info=$(echo $line | pup 'a.title text{}')
    # I really have to remove this ugly line
    tag=$(lower $(echo $line | pup 'span.linkflairlabel text{}'))

    if valid_url $url && current_tag $tag; then
      play_song $url $info
    fi
  done
}

while getopts ":t:" opt; do
  case $opt in
    t)
      USER_TAG=$(lower $OPTARG)
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

curl -s 'https://www.reddit.com/r/listentothis' | pup 'p.title' \
  | tr '\n' ' ' | ag -o '<p class="title">\K.*?(?=</p>)' \
  | read_song

