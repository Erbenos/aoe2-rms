#lang aoe2-rms
; Create 400 tiles worth of hills, with the number of hills scaling to map size.  On a small map this will be 4x2.1 = 8 clumps and a total of 400 tiles.

<ELEVATION-GENERATION>
(create-elevation 4
                  (base-terrain 'GRASS)
                  (number-of-tiles 400)
                  (number-of-clumps 4)
                  (set-scale-by-groups))
