#lang aoe2-rms
; Spawn a wolf next to each relic.

<OBJECTS-GENERATION>
(create-object 'RELIC
               (number-of-objects 5)
               (set-gaia-object-only)
               (temp-min-distance-group-placement 35)
               (actor-area 1234))

(create-object 'WOLF
               (number-of-objects 9320)
               (set-gaia-object-only)
               (actor-area-to-place-in 1234)
               (temp-min-distance-group-placement 25))
