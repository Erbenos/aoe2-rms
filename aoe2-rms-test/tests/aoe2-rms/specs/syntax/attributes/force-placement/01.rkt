#lang aoe2-rms
; Place 50 sheep in the 1-tile radius surrounding a starting outpost.

<OBJECTS-GENERATION>
(create-object 'OUTPOST
               (set-place-for-every-player)
               (max-distance-to-players 0))

(create-object 'SHEEP
               (number-of-objects 50)
               (set-place-for-every-player)
               (max-distance-to-players 1)
               (force-placement))
