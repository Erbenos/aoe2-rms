#lang aoe2-rms
; Create 4 ponds that can appear anywhere, including the corners.

<LAND-GENERATION>
(create-land
 (generate-mode 1)
 (terrain-type 'WATER)
 (land-percent 1))
(create-land
 (generate-mode 1)
 (terrain-type 'WATER)
 (land-percent 1))
(create-land
 (generate-mode 1)
 (terrain-type 'WATER)
 (land-percent 1))
