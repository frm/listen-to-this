# Listen To This

Playing [/r/listentothis](https://www.reddit.com/r/listentothis) music on your terminal.

Currently it is only allowing to reproduce YouTube clips and is only scrapping the front page. I intend to add SoundCloud and pagination, as well to search the daily, weekly, monthly, etc. top tracks.

You can filter through tags with the `-t` option, but it is only allowing one tag, yet. That'll change in the near future.

Keyboard shortcuts are available. Use `Ctrl-C` to exit, `q` to go to the next song, `p` pause the current song. All other mpv shortcuts are also available.

# Dependencies

* [mpv](https://github.com/mpv-player/mpv)
* [youtube-dl](https://github.com/rg3/youtube-dl/)
* [the_silver_searcher](https://github.com/ggreer/the_silver_searcher)
* [pup](https://github.com/EricChiang/pup)

# TODO

- [] Allow multiple labels
- [] Allow top pages scraping
- [] Add playlist rewind
- [] Add pagination
- [] Add track list printing
- [] Allow SoundCloud clips