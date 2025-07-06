#lang aoe2-rms
; Create 400 tiles worth of lakes, with the number of lakes AND the total number of tiles scaling to map size.  On a small map this will be 4x2.1 = 8 clumps with a total of 400*2.1 = 840 tiles.

<TERRAIN-GENERATION>
(create-terrain 'WATER
                (base-terrain 'GRASS)
                (number-of-tiles 400)
                (number-of-clumps 4)
                (set-scale-by-groups))
