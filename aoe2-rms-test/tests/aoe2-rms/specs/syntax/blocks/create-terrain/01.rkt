#lang aoe2-rms
; Create a large clump of forest terrain on grass terrain

<TERRAIN-GENERATION>
(create-terrain 'FOREST
                (base-terrain 'GRASS)
                (land-percent 10))
