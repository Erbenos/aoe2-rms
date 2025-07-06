#lang aoe2-rms
; Place an outpost on the map that will convert to the control of whoever is currently nearby.

<OBJECTS-GENERATION>
(create-object 'OUTPOST
               (set-gaia-object-only)
               (make-indestructible)
               (set-building-capturable))
