#lang aoe2-rms
; Create a hill where the bottom and top are desert, but the slope is grass

<ELEVATION-GENERATION>
(create-elevation 7
                  (base-terrain 'GRASS)
                  (number-of-tiles 3000)
                  (number-of-clumps 1))

<TERRAIN-GENERATION>
(create-terrain 'DESERT
                (base-terrain 'GRASS)
                (land-percent 10)
                (number-of-clumps 9320)
                (spacing-to-other-terrain-types 1)
                (set-flat-terrain-only))
