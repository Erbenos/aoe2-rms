#lang aoe2-rms
; Place a lumber camp on the nearest forest and place villagers there too.

<OBJECTS-GENERATION>
(create-object 'LUMBER_CAMP
               (set-place-for-every-player)
               (max-distance-to-players 67)
               (place-on-forest-zone)
               (find-closest)
               (actor-area 8)
               (actor-area-radius 4))

(create-object 'VILLAGER
               (set-place-for-every-player)
               (number-of-objects 4)
               (actor-area-to-place-in 8)
               (place-on-forest-zone)
               (find-closest))
