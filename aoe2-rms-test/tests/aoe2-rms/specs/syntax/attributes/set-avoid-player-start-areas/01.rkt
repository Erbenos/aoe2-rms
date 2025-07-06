#lang aoe2-rms
; Forest Nothing with small clearings

<TERRAIN-GENERATION>
(create-terrain 'FOREST
                (base-terrain 'GRASS)
                (land-percent 100)
                (number-of-clumps 999)
                (set-avoid-player-start-areas 2))
