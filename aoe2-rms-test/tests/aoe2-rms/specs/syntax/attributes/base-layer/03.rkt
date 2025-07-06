#lang aoe2-rms
; Layer desert on grass, and then place water on the layered desert.

<TERRAIN-GENERATION>
(create-terrain 'DESERT
                (base-terrain 'GRASS)
                (land-percent 10)
                (terrain-mask 1))

(create-terrain 'WATER
                (base-layer 'DESERT))
