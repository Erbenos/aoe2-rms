#lang aoe2-rms
; Create a palm desert land with elevation 2.

<LAND-GENERATION>
(create-land
 (terrain-type 'PALM_DESERT)
 (number-of-tiles 128)
 (base-elevation 2))

<ELEVATION-GENERATION>
