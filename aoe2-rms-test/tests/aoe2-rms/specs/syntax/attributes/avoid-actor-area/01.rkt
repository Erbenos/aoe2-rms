#lang aoe2-rms
; Place a barracks for empire wars but have it avoid various other objects that you already placed.

<OBJECTS-GENERATION>
(create-object 'BARRACKS
               (set-place-for-every-player)
               (min-distance-to-players 7)
               (max-distance-to-players 9)
               (avoid-actor-area 94)
               (avoid-actor-area 40)
               (avoid-actor-area 8)
               (avoid-actor-area 9)
               (avoid-actor-area 99)
               (avoid-actor-area 171)
               (actor-area 51)
               (actor-area-radius 5))
