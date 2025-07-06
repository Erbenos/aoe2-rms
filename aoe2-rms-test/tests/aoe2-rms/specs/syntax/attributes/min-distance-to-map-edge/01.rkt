#lang aoe2-rms
; Ensure that relics stay at least 10 tiles from the edge of the map.

<OBJECTS-GENERATION>
(create-object 'RELIC
               (set-gaia-object-only)
               (number-of-objects 500)
               (min-distance-to-map-edge 10))
