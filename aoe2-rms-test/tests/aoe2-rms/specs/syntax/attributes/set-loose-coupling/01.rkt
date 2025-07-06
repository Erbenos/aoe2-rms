#lang aoe2-rms
; Give players a group of 7 deer.

<OBJECTS-GENERATION>
(create-object 'DEER
               (number-of-objects 7)
               (number-of-groups 1)
               (group-placement-radius 5)
               (set-loose-grouping)
               (set-gaia-object-only)
               (set-place-for-every-player)
               (min-distance-to-players 14)
               (max-distance-to-players 22))
