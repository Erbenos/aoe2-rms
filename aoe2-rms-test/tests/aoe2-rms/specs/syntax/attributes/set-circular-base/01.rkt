#lang aoe2-rms
; Create a 12x12 circle of desert for each player

<LAND-GENERATION>
(create-player-lands
 (terrain-type 'DESERT)
 (land-percent 0)
 (base-size 12)
 (set-circular-base))
