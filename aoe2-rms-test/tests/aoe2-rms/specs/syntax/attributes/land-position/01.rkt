#lang aoe2-rms
; Create a lake in the center of the map

<LAND-GENERATION>
(create-land
 (terrain-type 'WATER)
 (land-percent 10)
 (land-position 50 50))
