#lang aoe2-rms
; Far player stone.

<OBJECTS-GENERATION>
(create-object 'STONE
               (number-of-objects 4)
               (group-placement-radius 2)
               (set-tight-grouping)
               (set-gaia-object-only)
               (set-place-for-every-player)
               (min-distance-to-players 20)
               (max-distance-to-players 27))
