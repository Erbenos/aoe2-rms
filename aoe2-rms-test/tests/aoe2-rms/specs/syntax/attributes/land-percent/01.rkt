#lang aoe2-rms
; Allocate 20% total of the map toward player lands

<LAND-GENERATION>
(create-player-lands
 (terrain-type 'DIRT)
 (land-percent 20))
