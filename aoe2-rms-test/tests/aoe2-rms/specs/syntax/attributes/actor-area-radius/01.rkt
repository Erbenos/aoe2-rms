#lang aoe2-rms
; Give each player a mill with 7 deer in a 7-tile radius.

<OBJECTS-GENERATION>
(create-object 'MILL
               (set-place-for-every-player)
               (min-distance-to-players 16)
               (max-distance-to-players 20)
               (actor-area 61)
               (actor-area-radius 7))

(create-object 'DEER
               (number-of-objects 7)
               (set-place-for-every-player)
               (set-gaia-object-only)
               (actor-area-to-place-in 61))
