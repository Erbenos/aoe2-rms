#lang aoe2-rms
; Place salmon on the land near each player's town center.  (Fish are can normally only be placed on water terrains)

<OBJECTS-GENERATION>
(create-object 'SALMON
               (number-of-objects 4)
               (set-place-for-every-player)
               (min-distance-to-players 3)
               (set-gaia-object-only)
               (find-closest)
               (ignore-terrain-restrictions))
