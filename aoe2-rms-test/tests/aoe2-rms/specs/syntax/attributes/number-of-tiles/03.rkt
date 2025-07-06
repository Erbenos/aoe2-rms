#lang aoe2-rms
; Create 500-tile lake.

<TERRAIN-GENERATION>
(create-terrain 'WATER
                (base-terrain 'GRASS)
                (number-of-tiles 500))
