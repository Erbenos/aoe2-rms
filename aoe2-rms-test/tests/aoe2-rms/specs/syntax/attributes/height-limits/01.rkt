#lang aoe2-rms
; Create a hill and place desert terrain only on the slopes

<ELEVATION-GENERATION>
(create-elevation 7 (base-terrain 'GRASS) (number-of-tiles 3000) (number-of-clumps 1))

<TERRAIN-GENERATION>
(create-terrain 'DESERT
                (base-terrain 'GRASS)
                (land-percent 100)
                (number-of-clumps 9320)
                (height-limits 1 6))
