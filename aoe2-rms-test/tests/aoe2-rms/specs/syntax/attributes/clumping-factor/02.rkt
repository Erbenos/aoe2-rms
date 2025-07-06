#lang aoe2-rms
; Create a regularly-shaped bamboo forest

<TERRAIN-GENERATION>
(create-terrain 'BAMBOO
                (base-terrain 'GRASS)
                (number-of-tiles 500)
                (clumping-factor 20))
