#lang aoe2-rms
; Generate forest that stays away from various terrains.

<TERRAIN-GENERATION>
(create-terrain 'FOREST
                (base-terrain 'GRASS)
                (land-percent 20)
                (number-of-clumps 30)
                (spacing-to-specific-terrain 'WATER 15)
                (spacing-to-specific-terrain 'SHALLOW 8)
                (spacing-to-specific-terrain 'ICE 6)
                (spacing-to-specific-terrain 'DESERT 3))
