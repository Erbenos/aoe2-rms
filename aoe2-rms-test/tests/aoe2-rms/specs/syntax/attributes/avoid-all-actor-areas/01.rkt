#lang aoe2-rms
; Place wolves that avoid all actor areas.

<OBJECTS-GENERATION>
(create-object 'TOWN_CENTER
               (set-place-for-every-player)
               (max-distance-to-players 0)
               (actor-area 100)
               (actor-area-radius 60))
(create-object 'WOLF
               (number-of-objects 9320)
               (temp-min-distance-group-placement 52)
               (avoid-all-actor-areas))
