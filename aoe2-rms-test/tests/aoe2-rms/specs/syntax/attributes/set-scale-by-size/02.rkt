#lang aoe2-rms
; Create 4 lakes which become larger on larger maps.  On a small map this will be 4 clumps with a total of 400*2.1 = 840 tiles.

<TERRAIN-GENERATION>
(create-terrain 'WATER
                (base-terrain 'GRASS)
                (number-of-tiles 400)
                (number-of-clumps 4)
                (set-scale-by-size))
