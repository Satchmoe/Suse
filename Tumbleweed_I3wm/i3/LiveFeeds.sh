#!/bin/bash

function play {
  setsid mpv -mute $1
}
# Wave 3 news
play http://www.wave3.com/category/200260/wave-3-live &

# TwitTV
play http://209.131.99.99/twit/live/low &

# Jupitor broudcasting
play rtmp://jblive.videocdn.scaleengine.net/jb-live/play/jblive.stream &

# ABC News
play http://abclive.abcnews.com/i/abc_live4@136330/index_1200_av-b.m3u8 &
