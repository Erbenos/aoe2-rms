#lang aoe2-rms
; Place a boar in the map center for each player.

<OBJECTS-GENERATION>
(create-object 'BOAR
               (set-place-for-every-player)
               (set-gaia-object-only)
               (find-closest-to-map-center))
