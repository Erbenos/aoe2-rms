#lang aoe2-rms
; Create 4 hills which become larger on larger maps.  On a small map this will be 4 clumps with a total of 400*2.1 = 840 tiles.

<ELEVATION-GENERATION>
(create-elevation 3
                  (base-terrain 'GRASS)
                  (number-of-tiles 400)
                  (number-of-clumps 4)
                  (set-scale-by-size))
