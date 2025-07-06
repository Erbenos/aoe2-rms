#lang aoe2-rms
; Place a relic on the map edge for each player.

<OBJECTS-GENERATION>
(create-object 'RELIC
               (set-place-for-every-player)
               (set-gaia-object-only)
               (find-closest-to-map-edge))
