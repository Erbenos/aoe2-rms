#lang aoe2-rms
; Scatter neutral gold evenly across the map.

<OBJECTS-GENERATION>
(create-object 'GOLD
               (number-of-objects 9320)
               (number-of-groups 4)
               (set-gaia-object-only)
               (set-tight-grouping)
               (min-distance-group-placement 4)
               (temp-min-distance-group-placement 46))
