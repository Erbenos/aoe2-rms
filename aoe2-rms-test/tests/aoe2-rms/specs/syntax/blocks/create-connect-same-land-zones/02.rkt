#lang aoe2-rms
; Connect player 2 and player 4

<LAND-GENERATION>
(create-player-lands
 (terrain-type 'DESERT)
 (land-percent 5))

<CONNECTION-GENERATION>
(create-connect-same-land-zones
 (default-terrain-replacement 'ROAD))
