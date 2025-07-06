#lang aoe2-rms
; Create one hill on water terrain.

<LAND-GENERATION>
(base-terrain 'DIRT)
(base-layer 'SNOW)

<ELEVATION-GENERATION>
(create-elevation 7
                  (base-terrain 'DIRT3)
                  (base-layer 'SNOW)
                  (number-of-tiles 9320)
                  (number-of-clumps 20))
