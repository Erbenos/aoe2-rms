#lang aoe2-rms
; Give every player their starting villagers.

<OBJECTS-GENERATION>
(create-object 'VILLAGER
               (set-place-for-every-player)
               (min-distance-to-players 6)
               (max-distance-to-players 7))
