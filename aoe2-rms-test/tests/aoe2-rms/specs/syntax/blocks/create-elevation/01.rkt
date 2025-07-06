#lang aoe2-rms
; Create one hill on grassy terrain.

<ELEVATION-GENERATION>
(create-elevation 7
                  (base-terrain 'GRASS)
                  (number-of-tiles 600))
