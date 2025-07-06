#lang aoe2-rms
; Place a central lake and then fill the map with gold that avoids being close to water.

<LAND-GENERATION>
(create-land
 (terrain-type 'WATER)
 (number-of-tiles 500)
 (land-position 50 50))

<OBJECTS-GENERATION>
(create-object 'GOLD
               (number-of-groups 9000)
               (set-gaia-object-only)
               (max-distance-to-other-zones 5))
