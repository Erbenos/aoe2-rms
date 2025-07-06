#lang aoe2-rms
; Give each player a fishing ship on the closest free water tile

<OBJECTS-GENERATION>
(create-object 'FISHING_SHIP
               (set-place-for-every-player)
               (ignore-terrain-restrictions)
               (terrain-to-place-on 'WATER)
               (find-closest))
