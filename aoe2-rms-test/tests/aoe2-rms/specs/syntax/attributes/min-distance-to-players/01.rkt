#lang aoe2-rms
; Place the starting scout at a distance of min 7 tiles.

<OBJECTS-GENERATION>
(create-object 'SCOUT
               (set-place-for-every-player)
               (min-distance-to-players 7))
