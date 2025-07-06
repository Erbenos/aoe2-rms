#lang aoe2-rms
; Create one hill on water terrain.

<ELEVATION-GENERATION>
(create-elevation 7
                  (base-terrain 'WATER)
                  (number-of-tiles 600))
