#lang aoe2-rms
; Directly place player 1 at the center of the map (50%, 50%)

<PLAYER-SETUP>
(direct-placement)

<LAND-GENERATION>
(create-land
 (terrain-type 'DESERT)
 (land-percent 3)
 (land-position 50 50)
 (assign-to-player 1))
