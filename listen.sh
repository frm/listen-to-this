#!/bin/bash

URL_REGEX="http(s)?://(www\.)?youtu(\.)?be"
USER_TAGS=()

URL_QUEUE=()
INFO_QUEUE=()

valid_url() {
   [[ $1 =~ $URL_REGEX ]]
}

contains_tag() {
  for t in "${USER_TAGS[@]}"; do
    [[ "$1" == "$t" ]] && return 0
  done
  return 1;
}

current_tag() {
  [[ ${#USER_TAGS[@]} -eq 0 ]] || contains_tag $1
}

music_info() {
  # Remove extra comments in the title
  echo $@ | ag -o '^.+ *--.+ *\[.+\] *\([0-9]+\)'
}

play_song() {
  echo "Now playing: ${*:2}"
  mpv --no-video $1
}

lower() {
  echo $@ | awk '{print tolower($0)}'
}

parse_tag() {
  echo $@
  lower $(echo $@ \
    | perl -MHTML::Entities -e 'while(<>) { print decode_entities($_); }')
}

read_songs() {
  while read -r line; do
    url=$(echo $line | pup 'a.title attr{href}')
    info=$(echo $line | pup 'a.title text{}')
    # I really have to remove this ugly line
    tag=$(parse_tag $(echo $line | pup 'span.linkflairlabel text{}'))

    if valid_url $url && current_tag $tag; then
      URL_QUEUE+=($url)
      INFO_QUEUE+=("$(music_info $info)")
    fi
  done
}

play() {
  if [[ ${#URL_QUEUE[@]} -eq 0 ]]; then
    echo "No songs available";
  else
    for ((i=0;i<${#URL_QUEUE[@]};++i)); do
      play_song ${URL_QUEUE[$i]} ${INFO_QUEUE[$i]}
    done
  fi
}

while getopts ":t:" opt; do
  case $opt in
    t)
      args=$(echo $OPTARG | tr ',' '\n')
      for arg in $args; do
        USER_TAGS+=($(lower $arg))
      done
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

# Exit using SIGINT instead of letting MPV capture the signal
_term() {
  exit 1
}

trap _term SIGINT

# Avoid sub-shell
read_songs < <(curl -s 'https://www.reddit.com/r/listentothis' | pup 'p.title' \
  | tr '\n' ' ' | ag -o '<p class="title">\K.*?(?=</p>)')

play
