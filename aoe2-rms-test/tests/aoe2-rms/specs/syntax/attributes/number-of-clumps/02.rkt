#lang aoe2-rms
; Create 40 forest clumps on grass terrain.

<TERRAIN-GENERATION>
(create-terrain 'FOREST
                (base-terrain 'GRASS)
                (land-percent 20)
                (number-of-clumps 40))
