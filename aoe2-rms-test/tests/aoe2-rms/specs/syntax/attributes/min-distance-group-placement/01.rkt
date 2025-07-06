#lang aoe2-rms
; Give each player two sets of forages and make them avoid each other by 4 tiles, and keep all future objects 4 tiles away.

<OBJECTS-GENERATION>
(create-object 'FORAGE
               (number-of-objects 7)
               (number-of-groups 2)
               (set-tight-grouping)
               (set-place-for-every-player)
               (set-gaia-object-only)
               (min-distance-to-players 8)
               (max-distance-to-players 10)
               (min-distance-group-placement 4))
