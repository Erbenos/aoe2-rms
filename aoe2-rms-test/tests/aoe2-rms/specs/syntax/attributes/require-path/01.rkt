#lang aoe2-rms
; Make sure a player boar isn't located behind nearby woodlines

<OBJECTS-GENERATION>
(create-object 'BOAR
               (set-place-for-every-player)
               (set-gaia-object-only)
               (require-path 1)
               (min-distance-to-players 16)
               (max-distance-to-players 22))
