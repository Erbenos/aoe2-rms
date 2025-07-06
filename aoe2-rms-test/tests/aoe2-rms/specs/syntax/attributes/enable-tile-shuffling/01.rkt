#lang aoe2-rms
; Create 4 individual gold mines randomly positioned in a circle around players, with no bias towards any position.

<OBJECTS-GENERATION>
(create-object 'GOLD
               (set-place-for-every-player)
               (set-gaia-object-only)
               (number-of-objects 4)
               (min-distance-to-players 12)
               (set-circular-placement)
               (find-closest)
               (enable-tile-shuffling))
