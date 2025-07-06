#lang aoe2-rms
; Create 4 hills of 100 tiles each.

<ELEVATION-GENERATION>
(create-elevation 3
                  (base-terrain 'GRASS)
                  (number-of-tiles 400)
                  (number-of-clumps 4))
