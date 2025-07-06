#lang aoe2-rms
; Create irregularly shaped lake

<LAND-GENERATION>
(create-land
 (terrain-type 'WATER)
 (land-percent 10)
 (clumping-factor 2))
