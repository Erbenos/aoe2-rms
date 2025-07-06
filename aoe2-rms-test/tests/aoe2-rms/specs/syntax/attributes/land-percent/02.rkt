#lang aoe2-rms
; Create a desert that covers 50% of the map

<TERRAIN-GENERATION>
(create-terrain 'DESERT
                (base-terrain 'GRASS)
                (land-percent 50))
