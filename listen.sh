#!/bin/bash

# Issues:
# Not showing info
# Only listening to youtube
# Not allowing to filter by tags
# Not allowing to only search on tops
mpv --no-video $(curl -s 'https://www.reddit.com/r/listentothis' \
  | tr '"' '\n' | egrep 'https://(www\.)?youtu(\.)?be' \
  | uniq | tr '\n' ' ')
