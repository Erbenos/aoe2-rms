#lang aoe2-rms
; Assign a desert land to player 1.

<PLAYER-SETUP>
(direct-placement)

<LAND-GENERATION>
(create-land
 (terrain-type 'DIRT)
 (number-of-tiles 128)
 (land-position 50 50)
 (assign-to 'AT_TEAM 1 0 0))
