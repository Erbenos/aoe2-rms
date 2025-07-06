#lang aoe2-rms
; Create a lake, and then fill the rest of the map with a forest which stays 10 tiles away from the water.

<TERRAIN-GENERATION>
(create-terrain 'WATER
                (base-terrain 'GRASS)
                (land-percent 10))

(create-terrain 'FOREST
                (base-terrain 'GRASS)
                (spacing-to-other-terrain-types 10)
                (land-percent 100))
