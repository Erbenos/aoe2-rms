#lang aoe2-rms
; Give each player forage bushes that must stay in a 3x3 area.

<OBJECTS-GENERATION>
(create-object 'FORAGE
               (number-of-objects 7)
               (set-tight-grouping)
               (group-placement-radius 1)
               (set-gaia-object-only)
               (set-place-for-every-player)
               (min-distance-to-players 7)
               (max-distance-to-players 8))
