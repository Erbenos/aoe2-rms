#lang aoe2-rms
; Place a barracks with the default actor_area_radius of 1, and then place a house adjacent, and prevent it from overlapping the barracks.

<OBJECTS-GENERATION>
(create-object 'BARRACKS
               (set-place-for-every-player)
               (find-closest)
               (actor-area 2))

(create-object 'HOUSE
               (set-place-for-every-player)
               (actor-area-to-place-in 2)
               (override-actor-radius-if-required))
