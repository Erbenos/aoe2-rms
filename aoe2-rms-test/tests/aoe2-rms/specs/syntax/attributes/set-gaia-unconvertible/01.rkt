#lang aoe2-rms
; Decorate the map with unrescuable gaia pyramids.

<OBJECTS-GENERATION>
(create-object 'PYRAMID
               (number-of-objects 3)
               (set-gaia-object-only)
               (set-gaia-unconvertible)
               (make-indestructible))
