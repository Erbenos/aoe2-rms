#lang aoe2-rms
; Place the starting scout at a distance of max 9 tiles.

<OBJECTS-GENERATION>
(create-object 'SCOUT
               (set-place-for-every-player)
               (max-distance-to-players 9))
