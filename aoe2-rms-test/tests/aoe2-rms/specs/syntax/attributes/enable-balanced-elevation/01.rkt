#lang aoe2-rms
; Spread a large number of hills fairly across the map.  Remove enable_balanced_elevation to see the difference.

<ELEVATION-GENERATION>
(create-elevation 7
                  (base-terrain 'GRASS)
                  (number-of-tiles 9320)
                  (number-of-clumps 9320)
                  (enable-balanced-elevation))
<TERRAIN-GENERATION>
(create-terrain 'DESERT
                (base-terrain 'GRASS)
                (land-percent 100)
                (number-of-clumps 9320)
                (height-limits 1 7))
