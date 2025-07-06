#lang aoe2-rms
; Create a large clump of forest terrain on grass terrain, then create water on the forest

<TERRAIN-GENERATION>
(create-terrain 'FOREST
                (base-terrain 'GRASS)
                (land-percent 10))

(create-terrain 'WATER
                (base-terrain 'FOREST))
