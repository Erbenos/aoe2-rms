#lang aoe2-rms
; Make a map generate somewhat larger than what is set in the lobby.

(%cond ['TINY_MAP (override-map-size 144)]
       ['SMALL_MAP (override-map-size 168)]
       ['MEDIUM_MAP (override-map-size 200)]
       ['LARGE_MAP (override-map-size 220)]
       ['HUGE_MAP (override-map-size 240)]
       ['GIGANTIC_MAP (override-map-size 255)])
